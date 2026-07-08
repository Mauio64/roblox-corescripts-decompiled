local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local SetFavoriteBundle = require(ParentParent.Actions.SetFavoriteBundle)
local createInspectAndBuyKeyMapper = require(ParentParent.createInspectAndBuyKeyMapper)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Network }
local v11 = createInspectAndBuyKeyMapper("getFavoriteForBundle")

local function GetFavoriteForBundle(p1) -- line: 20
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), v11 (copy), PerformFetch (copy), SetFavoriteBundle (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 21
		-- upvalues: Network (copy), v11 (copy), p1 (copy), PerformFetch (copy), SetFavoriteBundle (copy), SendCounter (copy), Constants (copy)
		local v16 = p3[Network]
		local v17 = v11(p2:getState().storeId, p1)

		return PerformFetch.Single(v17, function(_) -- line: 26
			-- upvalues: v16 (copy), p1 (copy), p2 (copy), SetFavoriteBundle (copy), SendCounter (copy), Constants (copy)
			return v16.getFavoriteForBundle(p1):andThen(function(p5) -- line: 27
				-- upvalues: p2 (copy), SetFavoriteBundle (copy), p1 (copy), SendCounter (copy), Constants (copy)
				if p5 == "null" then
					p2:dispatch(SetFavoriteBundle(tostring(p1), false))
				else
					p2:dispatch(SetFavoriteBundle(tostring(p1), true))
				end

				p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestSucceeded))
			end, function(_) -- line: 37
				-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
				p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestRejected))
			end)
		end)(p2):catch(function(_) -- line: 42
			-- upvalues: p2 (copy), SendCounter (copy), Constants (copy)
			p2:dispatch(SendCounter(Constants.Counters.GetFavoriteForBundle .. Constants.CounterSuffix.RequestFailed))
		end)
	end)
end

return GetFavoriteForBundle
