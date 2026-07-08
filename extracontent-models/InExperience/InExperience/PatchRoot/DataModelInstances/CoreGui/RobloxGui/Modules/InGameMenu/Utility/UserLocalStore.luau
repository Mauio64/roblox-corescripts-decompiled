local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function getCurrentUser() -- line: 5
	-- upvalues: Players (copy)
	if Players.LocalPlayer and Players.LocalPlayer.UserId > 0 then
		return (tostring(Players.LocalPlayer.UserId))
	end

	return "0"
end
local function getUserKey(p1) -- line: 14
	return "u_" .. tostring(p1 or "0")
end
local function getValuesForAllUsers(p2) -- line: 18
	-- upvalues: AppStorageService (copy), HttpService (copy)
	local Item = AppStorageService:GetItem(p2)
	local ok, result = pcall(function() -- line: 20
		-- upvalues: HttpService (copy), Item (copy)
		return HttpService:JSONDecode(Item)
	end)

	if ok and type(result) == "table" then
		return result
	end

	return {
		default = Item
	}
end
local function setValuesForAllUsers(p3, p4) -- line: 32
	-- upvalues: HttpService (copy), AppStorageService (copy)
	local json = HttpService:JSONEncode(p4)

	AppStorageService:SetItem(p3, json)
end

local t1 = {}

t1.__index = t1

function t1.new(p5) -- line: 40
	-- upvalues: Players (copy), t1 (copy)
	if not p5 then
		p5 = (not Players.LocalPlayer or not (Players.LocalPlayer.UserId > 0)) and "0" or tostring(Players.LocalPlayer.UserId)
	end

	local t2 = {
		userId = tostring(p5)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.GetItem(p6, p7) -- line: 52
	-- upvalues: getValuesForAllUsers (copy)
	local v21 = getValuesForAllUsers(p7)
	local v22 = v21["u_" .. tostring(p6.userId or "0")]

	if v22 == nil then
		v22 = v21.default
	end

	return v22
end
function t1.SetItem(p8, p9, p10) -- line: 62
	-- upvalues: getValuesForAllUsers (copy), HttpService (copy), AppStorageService (copy)
	local v26 = getValuesForAllUsers(p9)

	v26["u_" .. tostring(p8.userId or "0")] = p10

	local json = HttpService:JSONEncode(v26)

	AppStorageService:SetItem(p9, json)
end
function t1.Flush(_) -- line: 69
	-- upvalues: AppStorageService (copy)
	AppStorageService:Flush()
end

t1.getItem = t1.GetItem
t1.setItem = t1.SetItem
t1.flush = t1.Flush

return t1
