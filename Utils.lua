local _, addonTable = ...

local Utils = {}
addonTable.Utils = Utils

--[[
  Print a warning message to chat frame.
]]
function Utils:PrintWarning(...)
  local warningIcon = CreateAtlasMarkup("services-icon-warning", 16, 16)
  local message = table.concat({...}, " ")
  print(warningIcon, "|cfff8e928" .. message .. "|r")
end

--[[
  Attempt to load an addon. If it fails, a warning is printed to the chat frame.
  Returns true if the addon was loaded, false otherwise.
]]
function Utils:LoadAddon(name)
  if (not C_AddOns.IsAddOnLoaded(name)) then
    local loaded, reason = C_AddOns.LoadAddOn(name)

    if (not loaded) then
      Utils:PrintWarning(format(ADDON_LOAD_FAILED, name, _G["ADDON_" .. reason]))
      return false
    else
      return true
    end
  end

  return true
end

--[[
  Log data to DevTool addon. Recommended for debugging and addon development.

  See https://www.curseforge.com/wow/addons/devtool
]]
function Utils:Log(data, name)
  if (not Utils:LoadAddon("DevTool")) then
    return
  end

  name = name or tostring(data)

  if (DevToolFrame) then
    DevTool:AddData(data, name)
  else
    DevTool.list:AddNode(data, name)
  end
end

--[[
  Toggle DevTool dialog to see logs.

  See https://www.curseforge.com/wow/addons/devtool
]]
function Utils:ToggleLogs()
  if (Utils:LoadAddon("DevTool")) then
    DevTool:ToggleUI()
  end
end
