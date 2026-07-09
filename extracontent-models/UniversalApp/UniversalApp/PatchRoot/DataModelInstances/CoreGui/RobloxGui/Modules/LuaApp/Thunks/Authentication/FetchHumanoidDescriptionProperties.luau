local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(Modules.LuaApp.Promise)
local PromiseUtilities = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.PromiseUtilities
local Retry = require(Modules.LuaApp.Thunks.Networking.Util.Retry)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local HumanoidDescriptionProperties = require(Modules.LuaApp.Models.HumanoidDescriptionProperties)
local GetFIntLuaSignUpMaxRetries = require(Modules.LuaApp.Flags.GetFIntLuaSignUpMaxRetries)
local GetFIntLuaSignUpRetryTimeMultiplier = require(Modules.LuaApp.Flags.GetFIntLuaSignUpRetryTimeMultiplier)
local v11 = math.max(0, GetFIntLuaSignUpMaxRetries())
local v12 = math.max(0, GetFIntLuaSignUpRetryTimeMultiplier())
local SetHumanoidDescriptionProperties = require(Modules.LuaApp.Actions.Authentication.SetHumanoidDescriptionProperties)

return {
	Fetch = function(p1, p2) -- line: 22
		-- upvalues: Cryo (copy), WebApi (copy), PromiseUtilities (copy), HumanoidDescriptionProperties (copy), SetHumanoidDescriptionProperties (copy), Promise (copy), Retry (copy), v11 (copy), v12 (copy)
		return function(p3) -- line: 23
			-- upvalues: Cryo (copy), p2 (copy), WebApi (copy), p1 (copy), PromiseUtilities (copy), HumanoidDescriptionProperties (copy), SetHumanoidDescriptionProperties (copy), Promise (copy), Retry (copy), v11 (copy), v12 (copy)
			local u17 = Cryo.List.join(p2)

			local function fetchOutfitDetails() -- line: 26
				-- upvalues: u17 (ref), WebApi (copy), p1 (copy), PromiseUtilities (copy), HumanoidDescriptionProperties (copy), p3 (copy), SetHumanoidDescriptionProperties (copy), Promise (copy)
				local t1 = {}

				for _, v in pairs(u17) do
					t1[v] = WebApi.GetOutfit(p1, v)
				end

				return PromiseUtilities.Batch(t1):andThen(function(p4) -- line: 34
					-- upvalues: HumanoidDescriptionProperties (copy), p3 (copy), SetHumanoidDescriptionProperties (copy), Promise (copy)
					local t2 = {}
					local t3 = {}

					for k, v in pairs(p4) do
						local v28, v29 = v:unwrap()
						local v30 = v29 and v29.responseBody

						if v28 and v30 then
							t3[tostring(k)] = HumanoidDescriptionProperties.fromOutfitDetailsWebApi(v30)
						else
							table.insert(t2, k)
						end
					end

					p3:dispatch(SetHumanoidDescriptionProperties(t3))

					return Promise.resolve(t2)
				end)
			end

			return fetchOutfitDetails():andThen(function(p5) -- line: 57
				-- upvalues: Retry (copy), v11 (copy), v12 (copy), fetchOutfitDetails (copy), u17 (ref), Cryo (copy)
				return Retry({
					retryCount = v11,
					retryTimeMultiplier = v12,
					retryCallback = fetchOutfitDetails,
					previousResult = p5,
					isResolveConditionMet = function(p6) -- line: 63
						-- upvalues: u17 (ref), Cryo (copy)
						if #p6 == 0 then
							return true
						end

						u17 = Cryo.List.join(p6)

						return false
					end
				})
			end)
		end
	end
}
