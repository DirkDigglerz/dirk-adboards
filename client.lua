local myCID = false
local editAdvert = function(data)
  local newAd = lib.inputDialog('New Advertisement', {
    {type = 'input', label = 'Title', description = 'The title of your advertisement.', default = data.title or ''},
    {type = 'input', label = 'Subject', description = 'The subject of your advertisement.', default = data.subject or ''},
    {type = 'input', label = 'Description', description = 'The description of your advertisement.', default = data.description or ''},
    {type = 'input', label = 'Image URL', description = 'The image URL of your advertisement.', default = data.image or ''},
    {type = 'number', label = 'Phone Number', description = 'The phone number to contact.', default = data.phoneNumber or ''},
  })

  if newAd then 
    data.title = newAd[1]
    data.subject = newAd[2]
    data.description = newAd[3]
    data.image = newAd[4]
    data.phoneNumber = newAd[5]
  end

  return newAd, data
end


viewAllAds = function()
  local ads = Core.SyncCallback('dirk-adBoards:getAds')
  print('GOT ADS AS ')
  print(json.encode(ads))
  local options = {
    {
      title = "New Advertisement",
      icon  = "fas fa-plus",
      description = "Create a new advertisement.",
      
      onSelect = function()
        local newAd, data = editAdvert({})
        if newAd then 
          TriggerServerEvent('dirk-adBoards:newAd', data)
        end
        viewAllAds()
      end
    }

  }
  for k,v in pairs(ads) do
    print('MY CID ', myCID, v.authorID)
    table.insert(options, {
      title = v.title,
      icon  = v.image or "fas fa-ad",
      description = v.subject..'\n\n'..v.author..'\n'..v.date,
      image = v.image,
      metadata    = {
        {label = 'Phone Number', value = v.phoneNumber},
        {label = 'Description', value = v.description},
      },

      readOnly = (myCID ~= v.authorID),
      onSelect = function()
        local options = {
          {
            title = "Delete Advertisement",
            icon  = "fas fa-trash",
            description = "Delete this advertisement.",
            
            onSelect = function()
              TriggerServerEvent('dirk-adBoards:removeAd', v)
              viewAllAds()
            end
          }, 
          {
            title = "Edit Advertisement",
            icon  = "fas fa-edit",
            description = "Edit this advertisement.",

            onSelect = function()
              local newAd, data = editAdvert(v)
              if newAd then 
                TriggerServerEvent('dirk-adBoards:editAd', data)
              end
              viewAllAds()
            end
          }
        }

        lib.registerContext({
          id = 'adBoards_editAd',
          title = 'Edit Ad',
          menu  = 'adBoards_viewAds',
          onBack = function()
            viewAllAds()
          end,
          options = options,
        })

        lib.showContext('adBoards_editAd')
      end
    })
  end

  lib.registerContext({
    id = 'adBoards_viewAds',
    title = 'View Ads',
    options = options,
  })

  lib.showContext('adBoards_viewAds')
end


CreateThread(function()
  while not Core do Wait(500); end 
  while not Core.Player.Ready() do Wait(500); end
  myCID = Core.Player.Identifier()
  print('ADDING MODELS ', Config.adBoardModels)
  Core.Target.AddModels({
    Models   = Config.adBoardModels, 
    Distance = 5.0,
    Options = {
      {
        label = "View Ads",
        icon  = "fas fa-ad",
        canInteract = function()
          return true
        end,

        action = function()
          viewAllAds()
        end
      }
    }
  })
  

end)



local script_creator = exports['dirk-scriptCreator']
if script_creator then 
  -- script_creator:addComponent({

  -- })
end

