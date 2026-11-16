local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local Badge = Foundation.Badge
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableCustomTextInMenuTrailingBadge = SharedFlags.FFlagEnableCustomTextInMenuTrailingBadge

local Service = require(ChromeShared.Service)
local LocalStore = require(ChromeShared.Service.LocalStore)

require(CorePackages.Workspace.Packages.Chrome)

local signal = Signals.createSignal(nil)

local integrationIdSet = {}

local function hasBeenDismissed(integrationId: string, config): boolean -- 1 equivalent call inferred from this helper
	if integrationIdSet[integrationId] then
		return true
	end

	local maxViewCount = config.maxViewCount

	if maxViewCount <= 0 then
		return true
	end

	local value = LocalStore.getValue(config.localStorageKey)
	return maxViewCount <= (type(value) ~= "number" and 0 or value)
end

local function recordView(config) -- 1 equivalent call inferred from this helper
	if config.maxViewCount <= 0 then
		return
	end

	local value = LocalStore.getValue(config.localStorageKey)
	local v = type(value) ~= "number" and 0 or value
	LocalStore.storeForLocalPlayer(config.localStorageKey, v + 1)
end

local function renderBadge(text: string, layoutOrder: number?)
	return React.createElement(View, { tag = "auto-xy", LayoutOrder = layoutOrder }, {
		Badge = React.createElement(Badge, {
			text = text,
			variant = BadgeVariant.Emphasis,
			shape = BadgeShape.Box
		})
	})
end

local function MenuTrailingBadge(data)
	local integrationId = data.integrationId
	local config = data.config
	local v

	if FFlagEnableCustomTextInMenuTrailingBadge then
		v = SignalsReact.useSignalState(config.customText or signal)
	else
		v = nil
	end

	local state, setState = React.useState(function()
		local v2 = not hasBeenDismissed(integrationId, config) -- inferred equivalent call

		if not v2 or v ~= nil then
			return v2
		end

		recordView(config) -- inferred equivalent call
		return v2
	end)

	local v2 = useLocalization({ text = "Feature.Catalog.Label.New" })

	React.useEffect(function()
		if not state then
			return
		end

		local connection = Service:onIntegrationActivated():connect(function(p)
			if p ~= integrationId then
				return
			end

			integrationIdSet[integrationId] = true
			LocalStore.storeForLocalPlayer(config.localStorageKey, config.maxViewCount)
			setState(false)
		end)

		return function()
			connection:disconnect()
		end
	end, { integrationId, config.localStorageKey, config.maxViewCount, state })

	if v ~= nil then
		return renderBadge(v, data.layoutOrder)
	end

	if state then
		return renderBadge(v2.text, data.layoutOrder)
	end

	return nil
end

return MenuTrailingBadge
