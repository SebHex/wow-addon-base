local addonName, addonTable = ...

local Metadata = {}
addonTable.Metadata = Metadata

Metadata.Version = C_AddOns.GetAddOnMetadata(addonName, "version")
Metadata.Title = C_AddOns.GetAddOnMetadata(addonName, "title")
Metadata.Notes = C_AddOns.GetAddOnMetadata(addonName, "notes")
Metadata.Author = C_AddOns.GetAddOnMetadata(addonName, "author")
Metadata.DBName = addonName:gsub("_", "") .. "DB"
Metadata.Initials = Metadata.Title:gsub("([^%s])[^%s]*", "%1"):gsub("%s+", "")
