local Parent = script:FindFirstAncestor("LoginV2").Parent
local HttpService = game:GetService("HttpService")
local AccountService = game:GetService("AccountService")
local EngineFeature = game:GetEngineFeature("MagicLogin")
local React = require(Parent.React)
local Constants = require(script.Parent.Constants)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local PeekView = require(Parent.PeekView).PeekView
local PeekViewState = require(Parent.PeekView).PeekViewState
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local Dash = require(Parent.Dash)
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local Cell = UIBlox.App.Table.Cell
local useStyle = UIBlox.Core.Style.useStyle
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local Logger = require(Parent.Loggers).Logger
local useState = React.useState
local useEffect = React.useEffect

local function addDevice(t1: {[any]: any}, t2: {[any]: any}) -- line: 46
	local t3 = {}

	for i, v in ipairs(t1) do
		t3[i] = {
			endpointId = v.endpointId,
			endpointName = v.endpointName,
			endpointType = v.endpointType
		}
	end

	table.insert(t3, {
		endpointId = t2.endpointId,
		endpointName = t2.endpointName,
		endpointType = t2.endpointType
	})

	return t3
end
local function removeDevice(t4: {[any]: any}, s1: string) -- line: 67
	local t5 = {}

	for _, v in ipairs(t4) do
		if s1 ~= v.endpointId then
			table.insert(t5, {
				endpointId = v.endpointId,
				endpointName = v.endpointName,
				endpointType = v.endpointType
			})
		end
	end

	return t5
end
local function DeviceSelectorPeekView(t6: {[any]: any}) -- line: 84
	-- upvalues: useDispatch (copy), useState (copy), PeekViewState (copy), useStyle (copy), React (copy), useEffect (copy), AccountService (copy), EngineFeature (copy), HttpService (copy), Constants (copy), addDevice (copy), removeDevice (copy), Logger (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Cell (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), PeekView (copy), ScrollingListTable (copy), Dash (copy)
	local v40 = useDispatch()
	local v41, v42 = useState(PeekViewState.Full)
	local v43 = useStyle()
	local connection = nil
	local v45, v46 = React.useState({})

	useEffect(function() -- line: 96
		-- upvalues: AccountService (copy), EngineFeature (copy), connection (ref), HttpService (copy), Constants (copy), v46 (copy), addDevice (copy), removeDevice (copy), Logger (copy)
		if AccountService and EngineFeature then
			connection = AccountService.MagicLoginEvent:Connect(function(p1) -- line: 98
				-- upvalues: HttpService (copy), Constants (copy), v46 (copy), addDevice (copy), removeDevice (copy), Logger (copy)
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p1)

				if ok then
					if result.magicLoginActionKey == Constants.ENDPOINT_FOUND then
						v46(function(p2) -- line: 102
							-- upvalues: addDevice (copy), result (copy)
							return (addDevice(p2, {
								endpointId = result.endpointId,
								endpointName = result.endpointName,
								endpointType = result.endpointType
							}))
						end)

						return
					end

					if result.magicLoginActionKey == Constants.ENDPOINT_LOST then
						v46(function(p3) -- line: 110
							-- upvalues: removeDevice (copy), result (copy)
							return (removeDevice(p3, result.endpointId))
						end)

						return
					end

					if result.magicLoginActionKey == Constants.CLEAR_DEVICE_LIST then
						v46({})

						return
					end
				else
					Logger:warning("Magic login Failed to parse JSON data from string: " .. p1)
				end
			end)
			AccountService:MagicLogin(Constants.START_DISCOVERY)
		end

		return function() -- line: 123
			-- upvalues: AccountService (copy), EngineFeature (copy), connection (ref), Constants (copy)
			if AccountService and EngineFeature then
				if connection then
					connection:Disconnect()
				end

				AccountService:MagicLogin(Constants.STOP_DISCOVERY)
			end
		end
	end, {})

	local function onAccountSelection(t7: {[any]: any}) -- line: 148
		-- upvalues: v40 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t6 (copy)
		v40(SetCentralOverlay(CentralOverlayType.MagicLoginRequestPopup, {
			endpointId = t7.endpointId,
			endpointName = t7.endpointName,
			endpointType = t7.endpointType,
			launchApp = t6.launchApp
		}))
	end
	local function createDeviceSelectionCell(t8: {[any]: any}) -- line: 157
		-- upvalues: React (copy), Cell (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), v40 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t6 (copy), InputSize (copy), v43 (copy)
		return React.createElement(Cell, {
			onActivated = nil,
			horizontalPadding = 0,
			size = UDim2.new(1, 0, 0, 60),
			head = React.createElement(View, {
				tag = "col gap-xxsmall auto-xy"
			}, {
				nameText = React.createElement(FoundationText, {
					tag = "auto-xy text-title-medium text-wrap text-align-x-left",
					LayoutOrder = 0,
					Text = t8.endpointName or "Unknown"
				}),
				endpointTypeText = React.createElement(FoundationText, {
					tag = "auto-xy text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 1,
					Text = t8.endpointType or "Unknown"
				})
			}),
			tail = React.createElement(Button, {
				text = "Request",
				isDisabled = false,
				LayoutOrder = 0,
				variant = ButtonVariant.Standard,
				onActivated = function() -- line: 177
					-- upvalues: t8 (copy), v40 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t6 (copy)
					local v57 = t8

					v40(SetCentralOverlay(CentralOverlayType.MagicLoginRequestPopup, {
						endpointId = v57.endpointId,
						endpointName = v57.endpointName,
						endpointType = v57.endpointType,
						launchApp = t6.launchApp
					}))
				end,
				size = InputSize.Small,
				width = UDim.new(0, 80)
			}),
			background = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v43.Theme.BackgroundUIDefault.Color,
				BorderColor3 = v43.Theme.BackgroundUIDefault.Color
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full bg-action-alert"
	}, {
		PeekView = React.createElement(PeekView, {
			hasScrim = true,
			peekHeaderClose = false,
			canDragFullViewToBrief = true,
			mountAnimation = true,
			returnToFullView = true,
			thumbstickScrollEnabled = true,
			showDraggerInClosedState = true,
			isScrollingEnabled = true,
			showDropShadow = true,
			briefViewContentHeight = UDim.new(0, 270),
			superBriefViewContentHeight = UDim.new(0, 40),
			style = v43,
			stateOnMount = PeekViewState.Brief,
			peekHeaderPositionYChange = function(p4) -- line: 133
				-- upvalues: v42 (copy), PeekViewState (copy)
				if p4 < 10 then
					v42(PeekViewState.Closed)
				end
			end,
			viewStateChanged = function(p5, _) -- line: 139
				-- upvalues: v42 (copy), PeekViewState (copy), t6 (copy), v40 (copy)
				v42(p5)

				if (p5 == PeekViewState.Closed or p5 == PeekViewState.Hidden) and t6.closeCentralOverlayThunk then
					v40(t6.closeCentralOverlayThunk())
				end
			end,
			peekViewState = v41
		}, {
			PeekViewContent = React.createElement(View, {
				tag = "col gap-small auto-y size-full-0 padding-xxlarge"
			}, {
				TitleText = React.createElement(FoundationText, {
					Text = "Nearby Devices",
					tag = "auto-xy text-heading-medium text-wrap text-align-x-left",
					LayoutOrder = 0
				}),
				Body = React.createElement(View, {
					tag = "size-full",
					LayoutOrder = 1
				}, {
					VisibilityText = React.createElement(FoundationText, {
						Text = "",
						tag = "size-full text-body"
					}),
					DeviceList = React.createElement(ScrollingListTable, {
						cells = Dash.map(v45, createDeviceSelectionCell)
					})
				})
			})
		})
	})
end

return DeviceSelectorPeekView
