-- luacheck: globals tmr

Log.setLevel("INFO")


-- Importing third party json module
local json = require("json")

-- Lua table to store entries which should be shown at the UI
local messages = {
  {message = 'Init system', level = "info", timestamp = DateTime.getDateTime()},
  {message = 'System start', level = "info", timestamp = DateTime.getDateTime()},
  {message = 'System alert', level = "error", timestamp = DateTime.getDateTime()},
}

-- Timer for demonstration
tmr = Timer.create()
tmr:setPeriodic(true)
tmr:setExpirationTime(5000)
tmr:start()

--@handleOnExpired()
local function handleOnExpired()
  -- Adding a new row for demonstration
  table.insert(messages, {message = 'System had stopped', level = "warn", timestamp = DateTime.getDateTime()})
  
  -- Converting Lua table to json string
  local jsonstring = json.encode(messages)
  print("OnNewMessages: " .. jsonstring)
  -- Notify binding with new data
  Script.notifyEvent("OnNewMessages", jsonstring)
  
end
Timer.register(tmr, "OnExpired", handleOnExpired)
Script.serveEvent("DynamicTable.OnNewMessages", "OnNewMessages")

-- Function is bound to UI element and returns a json string with 
-- all table entries
--@getMessages():string
local function getMessages()
  -- Converting table to json string
  local jsonstring = json.encode(messages)
  print("getMessages: " .. jsonstring)

  return jsonstring
end
Script.serveFunction("DynamicTable.getMessages", getMessages)

-- Function is bound to UI and prints the data of a selected row
--@setSelection(data:string):
local function setSelection(data)
  print("setSelection:" .. data)
end
Script.serveFunction("DynamicTable.setSelection", setSelection)

