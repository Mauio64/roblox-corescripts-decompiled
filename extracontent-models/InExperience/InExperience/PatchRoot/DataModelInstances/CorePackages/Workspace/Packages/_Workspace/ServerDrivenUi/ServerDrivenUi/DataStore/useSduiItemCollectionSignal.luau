local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
require(parent.RobloxAppEnums)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local React = require(parent.React)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)
require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixInlineSignalsReactPattern = SharedFlags.FFlagLuaAppFixInlineSignalsReactPattern

local function useSduiItemCollectionSignal(p, p2, p3: number, p4: string?)
	local itemCollectionKey = getItemCollectionKey(p2, p3)
	local v = p4 or p

	if not FFlagLuaAppFixInlineSignalsReactPattern then
		return (SignalsReact.useSignalState(function(p5)
			return getSduiFeedStore(v).getItemCollection(itemCollectionKey, true)(p5)
		end))
	end

	local v2 = React.useCallback(function(p5)
		return getSduiFeedStore(v).getItemCollection(itemCollectionKey, true)(p5)
	end, { itemCollectionKey, v })

	return (SignalsReact.useSignalState(v2))
end

return useSduiItemCollectionSignal
