local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local NotificationService = game:GetService("NotificationService")
local BuildExperiencePlaytestLaunch = script:FindFirstAncestor("BuildExperiencePlaytestLaunch")
local SharedFlags = require(BuildExperiencePlaytestLaunch.Parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local function normalizeSelectedTheme(selectedTheme) -- 2 equivalent calls inferred from this helper
	if type(selectedTheme) == "string" then
		local v = string.lower(selectedTheme)

		if v == "light" or v == "dark" then
			return v
		end
	end

	return nil
end

local BuildModeLaunch = {}
BuildModeLaunch.__index = BuildModeLaunch

function BuildModeLaunch.new()
	return (setmetatable({
		cachedResult = nil,
		cachedSelectedTheme = nil,
		cachedChatSessionId = nil,
		cachedChatPlaceId = nil,
		cachedTeamTestPlaceId = nil
	}, BuildModeLaunch))
end

function BuildModeLaunch:set(chatSessionId: string?, p: number?, flag: boolean?)
	local v = { hasBuildMode = true }

	if flag then
		v.teamTestPlaceId = p
	end

	if FFlagBuildExperienceLibrary then
		self.cachedSelectedTheme = normalizeSelectedTheme(NotificationService.SelectedTheme) or self.cachedSelectedTheme -- inferred equivalent call
		v.selectedTheme = self.cachedSelectedTheme
		v.chatSessionId = chatSessionId
		v.chatPlaceId = p
	end

	self.cachedResult = nil
	MemStorageService:SetItem("BuildExperienceLaunchData", HttpService:JSONEncode(v))
end

function BuildModeLaunch:clear()
	self.cachedResult = nil
	MemStorageService:SetItem("BuildExperienceLaunchData", "")
end

function BuildModeLaunch:hasBuildMode()
	if self.cachedResult ~= nil then
		return self.cachedResult
	end

	if FFlagBuildExperienceLibrary then
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

	if FFlagBuildExperienceLibrary and self.cachedResult then
		self.cachedSelectedTheme = normalizeSelectedTheme(result.selectedTheme) -- inferred equivalent call

		if
			type(result.chatSessionId) == "string"
			and result.chatSessionId ~= ""
			and type(result.chatPlaceId) == "number"
		then
			self.cachedChatSessionId = result.chatSessionId
			self.cachedChatPlaceId = result.chatPlaceId
		end
	end

	return self.cachedResult
end

function BuildModeLaunch:applyViewerTheme()
	self:hasBuildMode()

	if self.cachedSelectedTheme ~= nil then
		NotificationService.SelectedTheme = self.cachedSelectedTheme
	end
end

function BuildModeLaunch:getChatSessionId(p: number)
	self:hasBuildMode()

	if self.cachedChatPlaceId == p then
		return self.cachedChatSessionId
	end

	return nil
end

function BuildModeLaunch:getTeamTestPlaceId()
	self:hasBuildMode()
	return self.cachedTeamTestPlaceId
end

return BuildModeLaunch
