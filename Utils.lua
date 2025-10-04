local addonName, addonTable = ...
local Metadata = addonTable.Metadata

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

--[[
  Toggle the options dialog.
]]
function Utils:ToggleDialog()
  local dialog = addonTable.Dialog
  local isShown = dialog:IsShown()

  if (isShown) then
    UIFrameFlash(dialog, 0.2, 0.2, 0.2, true, 0, 0)
  else
    ShowUIPanel(dialog)
  end
end

--[[
  Initialize the addon compartment function.
]]
function Utils:InitAddonCompartmentFunc()
  local addonCompartmentFuncName = addonName .. "_AddonCompartmentFunc"
  _G[addonCompartmentFuncName] = Utils.ToggleDialog
end

--[[
  Initialize the slash commands.
]]
function Utils:InitSlashCommands()
  local addonNameUpperCase = addonName:upper()
  local commands = {
    addonName,
    Metadata.Initials
  }

  for index, command in ipairs(commands) do
    local name = "SLASH_" .. addonNameUpperCase .. "_TOGGLE_DIALOG" .. index
    _G[name] = "/" .. command
  end

  SlashCmdList[addonNameUpperCase .. "_TOGGLE_DIALOG"] = Utils.ToggleDialog
end
