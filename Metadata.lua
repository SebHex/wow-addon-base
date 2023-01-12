local addonName, addonTable = ...

local Metadata = {}
addonTable.Metadata = Metadata

Metadata.Version = GetAddOnMetadata(addonName, "version")
Metadata.Title = GetAddOnMetadata(addonName, "title")
Metadata.Notes = GetAddOnMetadata(addonName, "notes")
Metadata.Author = GetAddOnMetadata(addonName, "author")
Metadata.DBName = addonName:gsub("_", "") .. "DB"
Metadata.Initials = Metadata.Title:gsub("([^%s])[^%s]*", "%1"):gsub("%s+", "")
