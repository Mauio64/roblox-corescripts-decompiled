local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local NotificationService = game:GetService("NotificationService")

local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags").FFlagBuildExperienceLibrary

local function normalizeSelectedTheme(value)
	if type(value) == "string" then
		local v5 = string.lower(value)

		if v5 == "light" or v5 == "dark" then
			return v5
		end
	end

	return nil
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({
		cachedResult = nil,
		cachedSelectedTheme = nil,
		cachedChatSessionId = nil,
		cachedChatPlaceId = nil,
		cachedTeamTestPlaceId = nil
	}, class))
end

function class:set(chatSessionId, p3, p4)
	local v5 = { hasBuildMode = true }

	if p4 then
		v5.teamTestPlaceId = p3
	end

	if fFlagBuildExperienceLibrary then
		local selectedTheme = NotificationService.SelectedTheme
		local v6

		if type(selectedTheme) == "string" then
			v6 = string.lower(selectedTheme)

			if v6 ~= "light" and v6 ~= "dark" then
				v6 = nil
			end
		end

		self.cachedSelectedTheme = v6 or self.cachedSelectedTheme
		v5.selectedTheme = self.cachedSelectedTheme
		v5.chatSessionId = chatSessionId
		v5.chatPlaceId = p3
	end

	self.cachedResult = nil
	MemStorageService:SetItem("BuildExperienceLaunchData", HttpService:JSONEncode(v5))
end

function class:clear()
	self.cachedResult = nil
	MemStorageService:SetItem("BuildExperienceLaunchData", "")
end

function class:hasBuildMode()
	if self.cachedResult ~= nil then
		return self.cachedResult
	end

	if fFlagBuildExperienceLibrary then
		self.cachedSelectedTheme = nil
		self.cachedChatSessionId = nil
		self.cachedChatPlaceId = nil
	end

	self.cachedTeamTestPlaceId = nil
	local item = MemStorageService:GetItem("BuildExperienceLaunchData")

	if item == "" then
		self.cachedResult = false
		return false
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, item)

	if not success or type(result) ~= "table" then
		self.cachedResult = false
		return false
	end

	MemStorageService:SetItem("BuildExperienceLaunchData", "")
	self.cachedResult = result.hasBuildMode == true

	if self.cachedResult and type(result.teamTestPlaceId) == "number" then
		self.cachedTeamTestPlaceId = result.teamTestPlaceId
	end

	if not (fFlagBuildExperienceLibrary and self.cachedResult) then
		return self.cachedResult
	end

	local selectedTheme = result.selectedTheme
	local v5

	if type(selectedTheme) == "string" then
		v5 = string.lower(selectedTheme)

		if v5 ~= "light" and v5 ~= "dark" then
			v5 = nil
		end
	end

	self.cachedSelectedTheme = v5

	if
		type(result.chatSessionId) == "string"
		and result.chatSessionId ~= ""
		and type(result.chatPlaceId) == "number"
	then
		self.cachedChatSessionId = result.chatSessionId
		self.cachedChatPlaceId = result.chatPlaceId
	end

	return self.cachedResult
end

function class:applyViewerTheme()
	self:hasBuildMode()

	if self.cachedSelectedTheme ~= nil then
		NotificationService.SelectedTheme = self.cachedSelectedTheme
	end
end

function class:getChatSessionId(p2)
	self:hasBuildMode()

	if self.cachedChatPlaceId == p2 then
		return self.cachedChatSessionId
	end

	return nil
end

function class:getTeamTestPlaceId()
	self:hasBuildMode()
	return self.cachedTeamTestPlaceId
end

return class
