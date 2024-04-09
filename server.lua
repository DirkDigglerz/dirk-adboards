local currentAds = {}


local generateAdId = function()
  local newID = string.format('news_ad_%s', math.random(100000, 999999))
  for k,v in pairs(currentAds) do
    if v.id == newID then 
      return generateAdId()
    end
  end
  return newID
end


post_to_discord = function()
  local content = {
    {
      ["color"] = 65280,
      ["title"] = "New Ad",
      ["description"] = "A new ad has been posted.",
      ["footer"] = {
        ["text"] = "dirk-adBoards",
      },
    }
  }
  PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = 'dirk-adBoards', embeds = content}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('dirk-adBoards:newAd', function(ad)
  local src = source
  local cost = Config.adCost
  if src ~= 0 then 
    if cost then 
      if not Core.Player.HasMoneyInAccount(src, Config.costAccount, Config.adCost) then 
        Core.UI.Notify(src, "You don't have enough money to post an ad.")
        return
      end
      Core.Player.RemoveMoney(src, Config.costAccount, Config.adCost)
    end
  end
  local first, last = Core.Player.Name(src)
  if not first then 
    first, last = 'Government', ''
  end
  ad.id = generateAdId()
  ad.author = first..' '..last or 'Government'
  ad.authorID = src and Core.Player.Id(src) or 'Government'
  ad.timeCreated = os.time()
  ad.date = os.date('%Y-%m-%d %H:%M:%S')

  table.insert(currentAds, ad)

  TriggerClientEvent('Dirk-Core:Notify', -1, {
    type = 'adBoard',
    title = 'New Ad',
    message = string.format('A new ad has been posted by %s', ad.author),
    duration = 10000,
  })

  Core.Files.Save('adBoards.json', currentAds)
end)

RegisterNetEvent('dirk-adBoards:editAd', function(ad)
  local src = source
  local myID = src and Core.Player.Id(src) or false 
  for k,v in pairs(currentAds) do
    if v.id == ad.id and ((v.authorID == myID) or (src == 0))then 
      currentAds[k] = ad
      break
    end
  end
  Core.Files.Save('adBoards.json', currentAds)
end)

RegisterNetEvent('dirk-adBoards:removeAd', function(ad)
  local src = source
  local myID = src and Core.Player.Id(src) or false 
  for k,v in pairs(currentAds) do
    if v.id == ad.id and ((v.authorID == myID) or (src == 0))then 
      table.remove(currentAds, k)
      break
    end
  end
  Core.Files.Save('adBoards.json', currentAds)
end)

CreateThread(function()
  while not Core do Wait(500); end
  local ads = Core.Files.Load('adBoards.json') or {}
  for k,v in pairs(ads) do
    local timeNow = os.time()
    local timeCreated = v.timeCreated or timeNow
    local timeDiff = timeNow - timeCreated
    if timeDiff < (Config.timeOut * 86400) then 
      table.insert(currentAds, v)
    end
  end
  Core.Callback('dirk-adBoards:getAds', function(source, cb)
    cb(currentAds)
  end)
end)


RegisterCommand('clearAds', function()
  currentAds = {}
  Core.Files.Save('adBoards.json', currentAds)
  print('^1DIRK-ADBOARDS^7 | ^1Cleared all ads. ^7')
end, true)