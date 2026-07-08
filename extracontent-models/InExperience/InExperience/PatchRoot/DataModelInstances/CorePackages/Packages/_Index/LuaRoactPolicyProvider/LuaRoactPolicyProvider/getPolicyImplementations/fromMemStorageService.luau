local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")
local v4 = game:DefineFastFlag("FFlagLogFirstGuacRead", false)
local v5 = game:DefineFastFlag("FFlagLogAllGuacRead", false)
local v6 = game:DefineFastFlag("CacheReadParsePolicy", false)
local v7 = game:DefineFastFlag("FixPolicyStalePlayerUpdates", false)
local v8 = game:DefineFastFlag("ClearPolicyOnLogout", false)
local default = nil

if v4 then
	local CorePackages = game:GetService("CorePackages")

	default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
end

return function(p1) -- line: 21
	-- upvalues: HttpService (copy), MemStorageService (copy), Players (copy), v6 (copy), v8 (copy), v7 (copy), v5 (copy), default (ref), v4 (copy)
	local v12 = p1 or {}

	v12.HttpService = v12.HttpService or HttpService
	v12.MemStorageService = v12.MemStorageService or MemStorageService
	v12.PlayersService = v12.PlayersService or Players
	assert(v12.HttpService, "expected dependencies.HttpService")
	assert(v12.MemStorageService, "expected dependencies.MemStorageService")
	assert(v12.PlayersService, "expected dependencies.PlayersService")

	local HttpService2 = v12.HttpService
	local MemStorageService2 = v12.MemStorageService
	local PlayersService = v12.PlayersService
	local u16 = false

	return function(p2) -- line: 36
		-- upvalues: PlayersService (copy), HttpService2 (copy), v6 (copy), v8 (copy), MemStorageService2 (copy), v7 (copy), v5 (copy), default (ref), v4 (copy), u16 (ref)
		assert(p2, "expected behavior")

		local function getStoreKey() -- line: 39
			-- upvalues: PlayersService (copy), p2 (copy)
			local n1 = -1
			local LocalPlayer = PlayersService.LocalPlayer

			if LocalPlayer and LocalPlayer.UserId > 0 then
				n1 = LocalPlayer.UserId
			end

			return "GUAC:" .. n1 .. ":" .. p2
		end

		local v19 = "GUAC:" .. -1 .. ":" .. p2
		local u20 = nil
		local u21 = nil
		local u22 = nil
		local u23 = nil
		local BindableEvent = Instance.new("BindableEvent")

		local function onPolicyUpdated(p3) -- line: 57
			-- upvalues: u22 (ref), HttpService2 (copy), u23 (ref), BindableEvent (copy)
			if p3 ~= u22 and (p3 and #p3 > 0) then
				local ok, result = pcall(function() -- line: 61
					-- upvalues: HttpService2 (copy), p3 (copy)
					return HttpService2:JSONDecode(p3)
				end)

				if ok then
					u22 = p3
					u23 = result
					BindableEvent:Fire(result)
				end
			end
		end

		if v6 then
			local u26 = nil

			local function invalidateForKeyChange() -- line: 77
				-- upvalues: v8 (copy), u20 (ref), u23 (ref), u22 (ref), u21 (ref), PlayersService (copy), p2 (copy), v19 (copy), MemStorageService2 (copy), onPolicyUpdated (copy)
				local v34 = if not v8 then nil else u20

				u23 = nil
				u22 = nil

				if u21 then
					u21:Disconnect()
					u21 = nil

					local n2 = -1
					local LocalPlayer = PlayersService.LocalPlayer

					if LocalPlayer and LocalPlayer.UserId > 0 then
						n2 = LocalPlayer.UserId
					end

					local v37 = "GUAC:" .. n2 .. ":" .. p2

					if v8 and v34 and v34 ~= v37 and v37 == v19 then
						MemStorageService2:RemoveItem(v37)
					end

					u20 = v37
					u21 = MemStorageService2:BindAndFire(v37, onPolicyUpdated)

					return
				end

				u20 = nil
			end
			local function localPlayerChanged() -- line: 104
				-- upvalues: u26 (ref), PlayersService (copy), v7 (copy), invalidateForKeyChange (copy), u23 (ref)
				if u26 then
					u26:Disconnect()
					u26 = nil
				end

				if PlayersService.LocalPlayer then
					u26 = PlayersService.LocalPlayer:GetPropertyChangedSignal("UserId"):Connect(function() -- line: 110
						-- upvalues: v7 (copy), invalidateForKeyChange (copy), u23 (ref)
						if v7 then
							invalidateForKeyChange()

							return
						end

						u23 = nil
					end)
				end

				if v7 then
					invalidateForKeyChange()

					return
				end

				u23 = nil
			end

			PlayersService:GetPropertyChangedSignal("LocalPlayer"):Connect(localPlayerChanged)
			localPlayerChanged()
		end

		return {
			read = function() -- line: 129
				-- upvalues: v6 (copy), u23 (ref), PlayersService (copy), p2 (copy), MemStorageService2 (copy), HttpService2 (copy), v5 (copy), default (ref), v4 (copy), u16 (ref), u22 (ref)
				if v6 and u23 then
					return u23
				end

				local n3 = -1
				local LocalPlayer = PlayersService.LocalPlayer

				if LocalPlayer and LocalPlayer.UserId > 0 then
					n3 = LocalPlayer.UserId
				end

				local v40 = "GUAC:" .. n3 .. ":" .. p2
				local Item = MemStorageService2:GetItem(v40)

				if Item and #Item > 0 then
					local ok, result = pcall(function() -- line: 136
						-- upvalues: HttpService2 (copy), Item (copy)
						return HttpService2:JSONDecode(Item)
					end)

					if ok then
						if v5 then
							default:logEvent("lua_policy_read_success")
						elseif v4 and not u16 then
							default:logEvent("lua_policy_read_success")
							u16 = true
						end

						u23 = result
						u22 = Item

						return result
					end
				end

				return nil
			end,
			onPolicyChanged = function(p4) -- line: 158
				-- upvalues: PlayersService (copy), p2 (copy), BindableEvent (copy), u21 (ref), u20 (ref), u23 (ref), MemStorageService2 (copy), onPolicyUpdated (copy)
				local n4 = -1
				local LocalPlayer = PlayersService.LocalPlayer

				if LocalPlayer and LocalPlayer.UserId > 0 then
					n4 = LocalPlayer.UserId
				end

				local v47 = "GUAC:" .. n4 .. ":" .. p2
				local connection = BindableEvent.Event:Connect(p4)

				if u21 and v47 == u20 then
					if u23 then
						p4(u23)

						return connection
					end
				else
					if u21 then
						u21:Disconnect()
					end

					u20 = v47
					u21 = MemStorageService2:BindAndFire(v47, onPolicyUpdated)
				end

				return connection
			end
		}
	end
end
