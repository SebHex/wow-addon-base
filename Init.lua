local addonName, addonTable = ...
local Metadata = addonTable.Metadata
local Utils = addonTable.Utils

-- Default options for AceDB database
local defaultDBOptions = {
  profile = {
    minimap = {
      hide = false
    }
  }
}

-- See https://www.wowace.com/projects/libdbicon-1-0
local minimapIconOptions = {
  icon = "Interface\\Icons\\Ability_Monk_CounteractMagic",
  OnTooltipShow = function(tooltip)
    tooltip:AddLine(Metadata.Title)
    tooltip:AddLine("Click to toggle the options menu")
  end,
  OnClick = function()
    Utils:ToggleConfigDialog()
  end
}

-- See https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
local configDialogOptions = {
  name = Metadata.Title,
  type = "group",
  args = {
    title = {
      order = 1,
      type = "description",
      fontSize = "large",
      image = "Interface\\Icons\\Ability_Monk_CounteractMagic",
      imageWidth = 24,
      imageHeight = 24,
      name = Metadata.Title
    },
    description = {
      order = 2,
      type = "description",
      fontSize = "medium",
      name = "A starting point for your next WoW addon."
    },
    divider = {
      order = 3,
      type = "header",
      name = ""
    },
    generalOptions = {
      order = 4,
      type = "group",
      name = "General",
      args = {
        minimapIcon = {
          order = 1,
          name = "Minimap icon",
          desc = "Show the minimap icon",
          type = "toggle",
          get = function(info)
            return not addonTable.db.profile.minimap.hide
          end,
          set = function(info, value)
            addonTable.db.profile.minimap.hide = not value
            Utils:SetMinimapIconShown(value)
          end
        }
      }
    }
  }
}

addonTable.Addon = Utils:CreateAddon(addonName, defaultDBOptions)
local Addon = addonTable.Addon

function Addon:OnInitialize()
  addonTable.db = Utils:CreateDB(self, Metadata.DBName, defaultDBOptions)
  addonTable.MinimapIcon = Utils:CreateMinimapIcon(minimapIconOptions)
  addonTable.ConfigDialog = Utils:CreateConfigDialog(configDialogOptions, 800, 540)
  self:RegisterChatCommand(Metadata.Initials, "SlashCommand")
end

function Addon:RefreshConfig(event)
  Utils:SetMinimapIconShown(not addonTable.db.profile.minimap.hide)
end

function Addon:SlashCommand(input)
  Utils:ToggleConfigDialog()
end
