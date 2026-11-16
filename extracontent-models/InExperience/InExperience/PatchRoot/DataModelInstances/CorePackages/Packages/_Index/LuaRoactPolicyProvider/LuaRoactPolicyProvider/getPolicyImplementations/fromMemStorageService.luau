local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")

local defineFastFlag = game:DefineFastFlag("FFlagLogFirstGuacRead", false)
local defineFastFlag2 = game:DefineFastFlag("FFlagLogAllGuacRead", false)
local defineFastFlag3 = game:DefineFastFlag("CacheReadParsePolicy", false)
local defineFastFlag4 = game:DefineFastFlag("FixPolicyStalePlayerUpdates", false)
local defineFastFlag5 = game:DefineFastFlag("ClearPolicyOnLogout", false)
local default

if defineFastFlag then
	local CorePackages = game:GetService("CorePackages")
	local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
	default = LoggingProtocol.default
else
	default = nil
end

return function(options)
	local v = options or {}
	v.HttpService = v.HttpService or HttpService
	v.MemStorageService = v.MemStorageService or MemStorageService
	v.PlayersService = v.PlayersService or Players

	assert(v.HttpService, "expected dependencies.HttpService")
	assert(v.MemStorageService, "expected dependencies.MemStorageService")
	assert(v.PlayersService, "expected dependencies.PlayersService")

	local httpService = v.HttpService
	local memStorageService = v.MemStorageService
	local playersService = v.PlayersService
	local v2 = false

	return function(p)
		assert(p, "expected behavior")

		local function getStoreKey() -- 3 equivalent calls inferred from this helper
			local localPlayer = playersService.LocalPlayer
			return "GUAC:" .. (not (localPlayer and localPlayer.UserId > 0) and -1 or localPlayer.UserId) .. ":" .. p
		end

		local v3 = "GUAC:" .. -1 .. ":" .. p

		local v4 = nil
		local connection = nil
		local v5 = nil
		local v6 = nil

		local bindableEvent = Instance.new("BindableEvent")

		local function onPolicyUpdated(json)
			if json ~= v5 and json and #json > 0 then
				local success, result = pcall(function()
					return httpService:JSONDecode(json)
				end)

				if success then
					v5 = json
					v6 = result
					bindableEvent:Fire(result)
				end
			end
		end

		if defineFastFlag3 then
			local userIdChangedConnection = nil
			local function invalidateForKeyChange()
				local v7

				if defineFastFlag5 then
					v7 = v4
				end

				v6 = nil
				v5 = nil

				if not connection then
					v4 = nil

					return
				end

				connection:Disconnect()
				connection = nil
				local storeKey = getStoreKey() -- inferred equivalent call

				if defineFastFlag5 and v7 and v7 ~= storeKey and storeKey == v3 then
					memStorageService:RemoveItem(storeKey)
				end

				v4 = storeKey
				connection = memStorageService:BindAndFire(storeKey, onPolicyUpdated)
			end
			local function localPlayerChanged()
				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				if playersService.LocalPlayer then
					userIdChangedConnection = playersService.LocalPlayer:GetPropertyChangedSignal("UserId"):Connect(function()
						if defineFastFlag4 then
							invalidateForKeyChange()
						else
							v6 = nil
						end
					end)
				end

				if defineFastFlag4 then
					invalidateForKeyChange()
				else
					v6 = nil
				end
			end
			playersService:GetPropertyChangedSignal("LocalPlayer"):Connect(localPlayerChanged)
			localPlayerChanged()
		end

		return {
			read = function()
				if defineFastFlag3 and v6 then
					return v6
				end

				local item = memStorageService:GetItem(getStoreKey()) -- inferred equivalent call

				if not (item and #item > 0) then
					return nil
				end

				local success, result = pcall(function()
					return httpService:JSONDecode(item)
				end)

				if not success then
					return nil
				end

				if defineFastFlag2 then
					default:logEvent("lua_policy_read_success")
				elseif defineFastFlag and not v2 then
					default:logEvent("lua_policy_read_success")
					v2 = true
				end

				v6 = result
				v5 = item
				return result
			end,
			onPolicyChanged = function(onEvent)
				local storeKey = getStoreKey() -- inferred equivalent call
				local eventConnection = bindableEvent.Event:Connect(onEvent)

				if connection and v4 == storeKey then
					if v6 then
						onEvent(v6)
						return eventConnection
					end
				else
					if connection then
						connection:Disconnect()
					end

					v4 = storeKey
					connection = memStorageService:BindAndFire(storeKey, onPolicyUpdated)
				end

				return eventConnection
			end
		}
	end
end
