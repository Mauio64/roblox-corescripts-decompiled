local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SignalsReact")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SduiSharedUtilities")

local ContentPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/ContentPage/ContentPageConstants")

local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef

local configKey = ContentPageConstants.ConfigKey

local function StreamNotificationsContentPage(p2)
	usePageScopeRef(configKey)
	local v5 = SignalsReact.useSignalState(getSduiApiStore().getData(configKey).data)

	local v6 = {}

	if v5 then
		for k, v7 in v5 do
			if
				v7.identifier
				and v7.identifier ~= ""
				and v7.identifier ~= ContentPageConstants.FeedEntryIdentifier
				and v7.config
			then
				table.insert(v6, v7)
			end
		end
	end

	table.sort(v6, function(a, b): boolean
		return a.identifier < b.identifier
	end)

	local children = {}

	for k, v7 in v6 do
		children[v7.identifier] = React.createElement(sduiFeatureEntryPoint, {
			configKey = configKey,
			identifier = v7.identifier,
			appPage = configKey,
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			LayoutOrder = k
		})
	end

	if #v6 > 0 then
		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = p2.LayoutOrder,
			Position = p2.Position
		}, children)
	end

	return nil
end

return StreamNotificationsContentPage
