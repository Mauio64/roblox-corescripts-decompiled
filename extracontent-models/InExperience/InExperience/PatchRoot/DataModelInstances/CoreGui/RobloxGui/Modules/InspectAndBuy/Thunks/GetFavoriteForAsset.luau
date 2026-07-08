local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SetFavoriteAsset = require(ParentParent.Actions.SetFavoriteAsset)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v11 = createInspectAndBuyKeyMapper("getFavoriteForAsset")

local function GetFavoriteForAsset(p1) -- line: 20
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v11 (copy), PerformFetch (copy), SetFavoriteAsset (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 21
		-- upvalues: Network (copy), v11 (copy), p1 (copy), PerformFetch (copy), SetFavoriteAsset (copy), SendCounter (copy), Constants (copy)
		local v16 = p3[Network]
		local v17 = v11(p2:getState().storeId, p1)

		return PerformFetch.Single(v17, function(_) -- line: 26
			-- upvalues: v16 (copy), p1 (copy), p2 (copy), SetFavoriteAsset (copy), SendCounter (copy), Constants (copy)
			return v16.getFavoriteForAsset(p1):andThen(function(p5) -- line: 27
				-- upvalues: p2 (copy), SetFavoriteAsset (copy), p1 (copy), SendCounter (copy), Constants (copy)
				if p5 == "null" then
					p2:dispatch(SetFavoriteAsset(tostring(p1), false))
				else
					p2:dispatch(SetFavoriteAsset(tostring(p1), true))
				end

				p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 37
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 42
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForAsset .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetFavoriteForAsset
