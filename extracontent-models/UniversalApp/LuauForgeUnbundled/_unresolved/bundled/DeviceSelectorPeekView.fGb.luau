local HttpService = game:GetService("HttpService")
local AccountService = game:GetService("AccountService")
local engineFeature = game:GetEngineFeature("MagicLogin")

local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fCC")
local module3 = require("@luauforge/bundled/fFl")
local module4 = require("@luauforge/bundled/fFp")
local button = module4.Button
local view = module4.View
local peekView = require("@luauforge/bundled/fGc").PeekView
local peekViewState = require("@luauforge/bundled/fGc").PeekViewState
local text = module4.Text
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local useDispatch = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useDispatch
local module5 = require("@luauforge/bundled/fGd")
local scrollingListTable = module3.App.Table.ScrollingListTable
local cell = module3.App.Table.Cell
local useStyle = module3.Core.Style.useStyle
local setCentralOverlay = require("@luauforge/bundled/fCt").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/fCG").CentralOverlayType
local logger = require("@luauforge/bundled/fCu").Logger

local useState = module.useState
local useEffect = module.useEffect

local function addDevice(list, data)
	local result = {}

	for i, item in ipairs(list) do
		result[i] = {
			endpointId = item.endpointId,
			endpointName = item.endpointName,
			endpointType = item.endpointType
		}
	end

	table.insert(result, {
		endpointId = data.endpointId,
		endpointName = data.endpointName,
		endpointType = data.endpointType
	})

	return result
end

local function removeDevice(list, endpointId)
	local result = {}

	for i, item in ipairs(list) do
		if endpointId ~= item.endpointId then
			table.insert(result, {
				endpointId = item.endpointId,
				endpointName = item.endpointName,
				endpointType = item.endpointType
			})
		end
	end

	return result
end

local function DeviceSelectorPeekView(p2)
	local v5 = useDispatch()
	local state, setState = useState(peekViewState.Full)
	local v6 = useStyle()

	local magicLoginEventConnection = nil

	local state2, setState2 = module.useState({})

	useEffect(function()
		if AccountService and engineFeature then
			magicLoginEventConnection = AccountService.MagicLoginEvent:Connect(function(p3)
				local success, result = pcall(HttpService.JSONDecode, HttpService, p3)

				if success then
					if result.magicLoginActionKey == module2.ENDPOINT_FOUND then
						setState2(function(p4)
							return addDevice(p4, {
								endpointId = result.endpointId,
								endpointName = result.endpointName,
								endpointType = result.endpointType
							})
						end)
					elseif result.magicLoginActionKey == module2.ENDPOINT_LOST then
						setState2(function(p4)
							return removeDevice(p4, result.endpointId)
						end)
					elseif result.magicLoginActionKey == module2.CLEAR_DEVICE_LIST then
						setState2({})
					end
				else
					logger:warning("Magic login Failed to parse JSON data from string: " .. p3)
				end
			end)

			AccountService:MagicLogin(module2.START_DISCOVERY)
		end

		return function()
			if AccountService and engineFeature then
				if magicLoginEventConnection then
					magicLoginEventConnection:Disconnect()
				end

				AccountService:MagicLogin(module2.STOP_DISCOVERY)
			end
		end
	end, {})

	local function peekHeaderPositionYChange(p3)
		if p3 < 10 then
			setState(peekViewState.Closed)
		end
	end

	local function fn(p3, p4)
		setState(p3)

		if (p3 == peekViewState.Closed or p3 == peekViewState.Hidden) and p2.closeCentralOverlayThunk then
			v5(p2.closeCentralOverlayThunk())
		end
	end

	local function onAccountSelection(data)
		v5(setCentralOverlay(centralOverlayType.MagicLoginRequestPopup, {
			endpointId = data.endpointId,
			endpointName = data.endpointName,
			endpointType = data.endpointType,
			launchApp = p2.launchApp
		}))
	end

	local function createDeviceSelectionCell(p3)
		return module.createElement(cell, {
			size = UDim2.new(1, 0, 0, 60),
			head = module.createElement(view, { tag = "col gap-xxsmall auto-xy" }, {
				nameText = module.createElement(text, {
					Text = p3.endpointName or "Unknown",
					tag = "auto-xy text-title-medium text-wrap text-align-x-left",
					LayoutOrder = 0
				}),
				endpointTypeText = module.createElement(text, {
					Text = p3.endpointType or "Unknown",
					tag = "auto-xy text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 1
				})
			}),
			tail = module.createElement(button, {
				text = "Request",
				variant = buttonVariant.Standard,
				onActivated = function()
					local v7 = p3
					v5(setCentralOverlay(centralOverlayType.MagicLoginRequestPopup, {
						endpointId = v7.endpointId,
						endpointName = v7.endpointName,
						endpointType = v7.endpointType,
						launchApp = p2.launchApp
					}))
				end,
				isDisabled = false,
				size = inputSize.Small,
				width = UDim.new(0, 80),
				LayoutOrder = 0
			}),
			background = module.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
				BackgroundTransparency = 1,
				BorderColor3 = v6.Theme.BackgroundUIDefault.Color
			}),
			onActivated = nil,
			horizontalPadding = 0
		})
	end

	return module.createElement(view, { tag = "size-full bg-action-alert" }, {
		PeekView = module.createElement(peekView, {
			hasScrim = true,
			briefViewContentHeight = UDim.new(0, 270),
			superBriefViewContentHeight = UDim.new(0, 40),
			peekHeaderClose = false,
			style = v6,
			canDragFullViewToBrief = true,
			stateOnMount = peekViewState.Brief,
			mountAnimation = true,
			returnToFullView = true,
			peekHeaderPositionYChange = peekHeaderPositionYChange,
			thumbstickScrollEnabled = true,
			showDraggerInClosedState = true,
			viewStateChanged = fn,
			peekViewState = state,
			isScrollingEnabled = true,
			showDropShadow = true
		}, {
			PeekViewContent = module.createElement(
				view,
				{ tag = "col gap-small auto-y size-full-0 padding-xxlarge" },
				{
					TitleText = module.createElement(text, {
						Text = "Nearby Devices",
						tag = "auto-xy text-heading-medium text-wrap text-align-x-left",
						LayoutOrder = 0
					}),
					Body = module.createElement(view, {
						tag = "size-full",
						LayoutOrder = 1
					}, {
						VisibilityText = module.createElement(text, {
							Text = "",
							tag = "size-full text-body"
						}),
						DeviceList = module.createElement(scrollingListTable, {
							cells = module5.map(state2, createDeviceSelectionCell)
						})
					})
				}
			)
		})
	})
end

return DeviceSelectorPeekView
