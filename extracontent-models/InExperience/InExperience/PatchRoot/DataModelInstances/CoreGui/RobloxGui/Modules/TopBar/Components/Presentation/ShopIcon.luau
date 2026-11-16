local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local chrome = CoreGui:WaitForChild("RobloxGui").Modules.Chrome

local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local useObservableValue = require(chrome.ChromeShared.Hooks.useObservableValue)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local GamepadConnector

if SharedFlags.FFlagEnableConsoleExpControls and enabled then
	GamepadConnector = require(script.Parent.Parent.GamepadConnector)
else
	GamepadConnector = nil
end

local ChromeUtils = require(chrome.ChromeShared.Service.ChromeUtils)
local observableValue = ChromeUtils.ObservableValue.new(true)

local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop

local v = InExperienceShop.FFlagEnableExperienceShopGlobalIcon and FFlagEnableInExperienceShop and enabled

local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local ShopGlobalIcon = InExperienceShop.ShopGlobalIcon
local CommonIcon

if v then
	CommonIcon = require(chrome.Integrations.CommonIcon)
else
	CommonIcon = nil
end

local Service

if v then
	Service = require(chrome.Service)
else
	Service = nil
end

local Constants

if v then
	Constants = require(chrome.ChromeShared.Unibar.Constants)
else
	Constants = nil
end

local useMappedSignal

if v then
	local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
	useMappedSignal = Chrome2.Hooks.useMappedSignal
else
	useMappedSignal = nil
end

local mappedSignal

if v and Service and Constants then
	local ChromeUtils2 = require(chrome.ChromeShared.Service.ChromeUtils)
	mappedSignal = ChromeUtils2.MappedSignal.new(Service:onIntegrationStatusChanged(), function()
		return Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID)
	end)
else
	mappedSignal = nil
end

local toggleInExperienceShopWindow

if v then
	local ShopWindowLayout = require(chrome.Integrations.InExperienceShop.ShopWindowLayout)
	toggleInExperienceShopWindow = ShopWindowLayout.toggleInExperienceShopWindow
else
	toggleInExperienceShopWindow = nil
end

local function getShopGlobalIconEnabled(p)
	if not v then
		return false
	end

	local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if getShopGlobalIconStore then
		return (getShopGlobalIconStore(p).getEnabled(p))
	end

	return false
end

local function getShopGlobalStatusIndicatorEnabled(p)
	if not v then
		return false
	end

	local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

	if getShopGlobalIconStore then
		return (getShopGlobalIconStore(p).getStatusIndicatorEnabled(p))
	end

	return false
end

local function handleShopGlobalIconActivated()
	if not v then
		return
	end

	if FFlagCenterInExperienceShopWindow then
		if toggleInExperienceShopWindow then
			toggleInExperienceShopWindow()
		end
	elseif Service and Constants then
		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end
end

local function ShopIcon(props)
	local v2 = SignalsReact.useSignalState(getShopGlobalIconEnabled)
	local showStatusIndicator = SignalsReact.useSignalState(getShopGlobalStatusIndicatorEnabled)

	React.useEffect(function()
		if v then
			return InExperienceShop.initShopGlobalIcon and InExperienceShop.initShopGlobalIcon() or function() end
		end
	end, {})
	local v3

	if v2 then
		v3 = mappedSignal
	end

	local isActive = (useMappedSignal or function(): nil
		return nil
	end)(v3)
	local v4

	if GamepadConnector == nil then
		v4 = observableValue
	else
		v4 = GamepadConnector:getShowTopBar()
	end

	local v5 = useObservableValue(v4)

	if not (v and v2 and ShopGlobalIcon) then
		return nil
	end

	local createElement = React.createElement
	local v6 = {
		Size = UDim2.fromOffset(0, props.buttonSize),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v7 = {
		buttonSize = props.buttonSize,
		leftGap = props.leftGap,
		hidden = v5 == false,
		showStatusIndicator = showStatusIndicator,
		onActivated = handleShopGlobalIconActivated,
		onAreaChanged = props.onAreaChanged,
		isActive = isActive,
		icon = 0
	}
	local icon

	if not (FFlagExperienceShopNewIconography or not (CommonIcon and mappedSignal)) then
		icon = CommonIcon("BuildingStore", nil, mappedSignal)
	end

	v7.icon = icon
	return createElement("Frame", v6, {
		Icon = createElement2(ShopGlobalIcon, v7)
	})
end

return ShopIcon
