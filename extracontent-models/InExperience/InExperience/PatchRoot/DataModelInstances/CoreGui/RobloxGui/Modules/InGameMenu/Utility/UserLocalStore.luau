local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function getCurrentUser() -- 1 equivalent call inferred from this helper
	if Players.LocalPlayer and Players.LocalPlayer.UserId > 0 then
		return (tostring(Players.LocalPlayer.UserId))
	end

	return "0"
end

local function getUserKey(userId) -- 2 equivalent calls inferred from this helper
	return "u_" .. tostring(userId or "0")
end

local function getValuesForAllUsers(p)
	local item = AppStorageService:GetItem(p)
	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	if success and type(result) == "table" then
		return result
	end

	return { default = item }
end

local function setValuesForAllUsers(p, valuesForAllUsers) -- 1 equivalent call inferred from this helper
	AppStorageService:SetItem(p, (HttpService:JSONEncode(valuesForAllUsers)))
end

local UserLocalStore = {}
UserLocalStore.__index = UserLocalStore

function UserLocalStore.new(p)
	local v = {
		userId = tostring(p or getCurrentUser()) -- inferred equivalent call
	}

	setmetatable(v, UserLocalStore)
	return v
end

function UserLocalStore:GetItem(p)
	local valuesForAllUsers = getValuesForAllUsers(p)
	local item = valuesForAllUsers[getUserKey(self.userId)] -- inferred equivalent call

	if item == nil then
		item = valuesForAllUsers.default
	end

	return item
end

function UserLocalStore:SetItem(p, p2)
	local valuesForAllUsers = getValuesForAllUsers(p)
	valuesForAllUsers[getUserKey(self.userId)] = p2 -- inferred equivalent call
	setValuesForAllUsers(p, valuesForAllUsers) -- inferred equivalent call
end

function UserLocalStore:Flush()
	AppStorageService:Flush()
end

UserLocalStore.getItem = UserLocalStore.GetItem
UserLocalStore.setItem = UserLocalStore.SetItem
UserLocalStore.flush = UserLocalStore.Flush

return UserLocalStore
