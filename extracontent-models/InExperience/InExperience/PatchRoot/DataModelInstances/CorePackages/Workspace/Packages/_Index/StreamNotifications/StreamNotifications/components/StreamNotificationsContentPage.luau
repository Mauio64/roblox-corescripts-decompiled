local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local ContentPageConstants = require(StreamNotifications.ContentPage.ContentPageConstants)

local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef

local ConfigKey = ContentPageConstants.ConfigKey

local function StreamNotificationsContentPage(p)
	usePageScopeRef(ConfigKey)
	local v = SignalsReact.useSignalState(getSduiApiStore().getData(ConfigKey).data)

	local v2 = {}

	if v then
		for _, v3 in v do
			if
				v3.identifier
				and v3.identifier ~= ""
				and v3.identifier ~= ContentPageConstants.FeedEntryIdentifier
				and v3.config
			then
				table.insert(v2, v3)
			end
		end
	end

	table.sort(v2, function(a, b): boolean
		return a.identifier < b.identifier
	end)

	local children = {}

	for k, v3 in v2 do
		children[v3.identifier] = React.createElement(SduiFeatureEntryPoint, {
			configKey = ConfigKey,
			identifier = v3.identifier,
			appPage = ConfigKey,
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			LayoutOrder = k
		})
	end

	if #v2 > 0 then
		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = p.LayoutOrder,
			Position = p.Position
		}, children)
	end

	return nil
end

return StreamNotificationsContentPage
