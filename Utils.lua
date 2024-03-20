local addonName, addonTable = ...
local Metadata = addonTable.Metadata
local Libs = addonTable.Libs
local AceAddon = Libs.AceAddon
local AceDB = Libs.AceDB
local LibDataBroker = Libs.LibDataBroker
local LibDBIcon = Libs.LibDBIcon
local AceDBOptions = Libs.AceDBOptions
local AceConfig = Libs.AceConfig
local AceConfigDialog = Libs.AceConfigDialog
local AceConfigRegistry = Libs.AceConfigRegistry

local Utils = {}
addonTable.Utils = Utils

--[[
  Print a warning message to chat frame
]]
function Utils:PrintWarning(...)
  local warningIcon = CreateAtlasMarkup("services-icon-warning", 16, 16)
  local message = table.concat({...}, " ")
  print(warningIcon, "|cfff8e928" .. message .. "|r")
end

--[[
  Attempt to load an addon. If it fails, a warning is printed to the chat frame.
  Returns true if the addon was loaded, false otherwise
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
  Log data to DevTool addon. Recommended for debugging and addon development

  See https://github.com/brittyazel/DevTool
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
  Toggle DevTool dialog to see logs

  See https://github.com/brittyazel/DevTool
]]
function Utils:ToggleLogsDialog()
  if (Utils:LoadAddon("DevTool")) then
    DevTool:ToggleUI()
  end
end

--[[
  Create an addon using Ace3

  See https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0
]]
function Utils:CreateAddon(name)
  return AceAddon:NewAddon(name, "AceConsole-3.0", "AceEvent-3.0")
end

--[[
  Create a db using Ace3

  See https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
]]
function Utils:CreateDB(addon, name, defaultOptions)
  local db = AceDB:New(name, defaultOptions, true)
  db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
  db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")
  db.RegisterCallback(addon, "OnProfileReset", "RefreshConfig")

  return db
end

--[[
  Create a minimap icon using LibDataBroker and LibDBIcon
]]
function Utils:CreateMinimapIcon(options)
  local minimapIconData = LibDataBroker:NewDataObject(addonName, options)
  LibDBIcon:Register(addonName, minimapIconData, addonTable.db.profile.minimap)

  return LibDBIcon
end

--[[
  Create a config dialog using Ace3
]]
function Utils:CreateConfigDialog(options, width, height)
  options.args.profile = AceDBOptions:GetOptionsTable(addonTable.db)
  AceConfig:RegisterOptionsTable(addonName, options)
  AceConfigDialog:AddToBlizOptions(addonName, Metadata.Title)
  AceConfigDialog:SetDefaultSize(addonName, width, height)

  return AceConfigDialog
end

--[[
  Show or hide minimap icon
]]
function Utils:SetMinimapIconShown(shown)
  if (shown) then
    LibDBIcon:Show(addonName)
  else
    LibDBIcon:Hide(addonName)
  end
end

--[[
  Get config dialog options
]]
function Utils:GetConfigDialogOptions()
  return AceConfigRegistry:GetOptionsTable(addonName, "dialog", "AceConfigDialog-3.0")
end

local configDialogStatusText = format("|cff808080Version: %s • Author: %s|r", Metadata.Version, Metadata.Author)

--[[
  Open config dialog
]]
function Utils:OpenConfigDialog()
  if (AceConfigDialog.OpenFrames[addonName]) then
    return
  end

  AceConfigDialog:Open(addonName)
  AceConfigDialog.OpenFrames[addonName]:SetStatusText(configDialogStatusText)
end

--[[
  Close config dialog
]]
function Utils:CloseConfigDialog()
  AceConfigDialog:Close(addonName)
end

--[[
  Toggle config dialog
]]
function Utils:ToggleConfigDialog()
  local isOpen = AceConfigDialog.OpenFrames[addonName]

  if (isOpen) then
    Utils:CloseConfigDialog()
  else
    Utils:OpenConfigDialog()
  end
end
