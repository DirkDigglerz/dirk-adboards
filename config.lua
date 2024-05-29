Config = {
  adCost = 5000, 
  timeOut  = 1, --## Days before ad expires
  costAccount = 'bank',
  adBoardModels = {
    'prop_news_disp_01a',
    'prop_news_disp_02a',
    'prop_news_disp_02c',
    'prop_news_disp_03a',
    'prop_news_disp_04a',
    'prop_news_disp_05a',

  },


  locked_jobs = { --## Delete this entire table if you dont want to lock any jobs
    lspd = true
  },


}

Core, Settings = exports['dirk-core']:getCore()