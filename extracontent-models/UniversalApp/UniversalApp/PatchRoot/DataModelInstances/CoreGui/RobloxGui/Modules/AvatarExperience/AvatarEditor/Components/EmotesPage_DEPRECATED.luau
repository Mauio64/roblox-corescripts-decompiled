local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Cryo = require(CorePackages.Packages.Cryo)
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local EquipSlots = require(Modules.AvatarExperience.AvatarEditor.Components.EquipSlots)
local ItemsList = require(Modules.AvatarExperience.AvatarEditor.Components.ItemsList)
local SetSelectedEmoteSlot = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedEmoteSlot)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v22 = Roact.PureComponent:extend("EmotesPage")

function v22.init(p1) -- line: 42
	-- upvalues: Roact (copy), UserInputService (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), AvatarScreen (copy)
	p1.equipSlotsRef = Roact.createRef()
	p1.itemsListRef = Roact.createRef()
	p1:setState({
		equipSlotsFocused = false,
		itemsListFocused = false,
		lastInputType = UserInputService:GetLastInputType()
	})

	function p1.onEquipSlotsFocusChanged(p2) -- line: 51
		-- upvalues: p1 (copy)
		p1:setState({
			equipSlotsFocused = p2
		})
	end
	function p1.onItemsListFocusChanged(p3) -- line: 57
		-- upvalues: p1 (copy)
		p1:setState({
			itemsListFocused = p3
		})
	end
	function p1.onSlotActivated(p4) -- line: 63
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p1 (copy), Constants (copy), AvatarScreen (copy)
		if p1.props.avatarType == Constants.AvatarType.R6 then
			p1.props.navigation.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt",
				onOverlayClosed = function() -- line: 64
					-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p1 (copy)
					local v44 = wasLastInputGamepad()

					logOnOverlayClosed("EmotesPage", v44)

					if not FFlagAXMigrateAXToGlobalAutofocus and v44 then
						p1.props.focusController.captureFocus()
					end
				end
			})
		end

		p1.props.setSelectedEmoteSlot(p4)
	end
end
function v22.render(p5) -- line: 87
	-- upvalues: withStyle (copy), isGamepadInput (copy), AvatarScreen (copy), Roact (copy), Focusable (copy), EquipSlots (copy), ItemsList (copy), ExternalEventConnection (copy), UserInputService (copy)
	return withStyle(function(p6) -- line: 90
		-- upvalues: p5 (copy), isGamepadInput (copy), AvatarScreen (copy), Roact (copy), Focusable (copy), EquipSlots (copy), ItemsList (copy), ExternalEventConnection (copy), UserInputService (copy)
		local Overlay = p6.Theme.Overlay
		local lockNavigationCallback = p5.props.lockNavigationCallback
		local unlockNavigationCallback = p5.props.unlockNavigationCallback
		local categoryInfo = p5.props.categoryInfo
		local onSlotActivated = p5.onSlotActivated
		local v41 = isGamepadInput(p5.state.lastInputType) and p5.props.avatarRoute.current.name == AvatarScreen.ItemDetails

		return Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			defaultChild = p5.equipSlotsRef,
			restorePreviousChildFocus = p5.props.restorePreviousChildFocus
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			EquipSlots = Roact.createElement(EquipSlots, {
				slotsCount = categoryInfo.EquipSlotsCount,
				lockNavigationCallback = lockNavigationCallback,
				unlockNavigationCallback = unlockNavigationCallback,
				onActivated = onSlotActivated,
				LayoutOrder = 1,
				NextSelectionUp = p5.props.NextSelectionUp,
				itemsListRef = p5.itemsListRef,
				[Roact.Ref] = p5.equipSlotsRef,
				onFocusChanged = p5.onEquipSlotsFocusChanged,
				itemsListFocused = p5.state.itemsListFocused,
				darkenItemsGrid = v41
			}),
			Tiles = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, -72)
			}, {
				GamepadDarkOverlay = p5.state.equipSlotsFocused and Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = Overlay.Transparency,
					BackgroundColor3 = Overlay.Color
				}),
				ItemsList = Roact.createElement(ItemsList, {
					buttonBInputRef = p5.equipSlotsRef,
					[Roact.Ref] = p5.itemsListRef,
					onFocusChanged = p5.onItemsListFocusChanged,
					darkenItemsGrid = v41
				})
			}),
			LastInputChangedListener = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = function(p7) -- line: 150
					-- upvalues: p5 (copy)
					p5:setState({
						lastInputType = p7
					})
				end
			})
		})
	end)
end

local function mapStateToProps(p8, _) -- line: 160
	return {
		avatarType = p8.AvatarExperience.AvatarEditor.Character.AvatarType
	}
end
local function mapDispatchToProps(p10) -- line: 166
	-- upvalues: SetSelectedEmoteSlot (copy)
	return {
		setSelectedEmoteSlot = function(p11) -- line: 168
			-- upvalues: p10 (copy), SetSelectedEmoteSlot (copy)
			p10(SetSelectedEmoteSlot(p11))
		end
	}
end

local u25 = withAvatarRoute((withNavigation(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v22), nil)))

if FFlagAXMigrateAXToGlobalAutofocus then
	return u25
end

return function(p12) -- line: 184
	-- upvalues: RoactGamepad (copy), Roact (copy), u25 (ref), Cryo (copy)
	return RoactGamepad.withFocusController(function(p13) -- line: 185
		-- upvalues: Roact (copy), u25 (ref), Cryo (copy), p12 (copy)
		return Roact.createElement(u25, Cryo.Dictionary.join(p12, {
			focusController = p13
		}))
	end)
end
