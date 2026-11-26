local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/fbO")
local module4 = require("@luauforge/deferred/ekp")
local module5 = require("@luauforge/deferred/fce")
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module6 = require("@luauforge/deferred/ekv")
local module7 = require("@luauforge/deferred/fcf")
local module8 = require("@luauforge/deferred/ekB")
local module9 = require("@luauforge/deferred/elj")
local module10 = require("@luauforge/deferred/fcm")
local module11 = require("@luauforge/deferred/fcl")

local dialog = Foundation.Dialog
local iconButton = Foundation.IconButton
local menu = Foundation.Menu
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local orientation = Foundation.Enums.Orientation
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local useDispatch = module3.Hooks.RoactRodux.useDispatch
local useNavigation = module4.useNavigation

local udim = UDim.new(0, 200)

local function SchoolOverflowMenu(p2)
	local v5 = useDispatch()
	local v7 = module9((useNavigation()))
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(false)
	local ref = module.useRef(true)

	module.useEffect(function()
		return function()
			ref.current = false
		end
	end, {})

	local v8 = useLocalization({
		leaveSchool = module6.ActionLeaveSchool,
		cancel = module6.ActionCancel,
		removeSchoolTitle = module6.RemoveSchoolTitle,
		removeSchoolBody = module6.RemoveSchoolBody,
		removeSchoolConfirm = module6.RemoveSchoolConfirm,
		somethingWentWrong = module6.SomethingWentWrong
	})

	local v9 = module.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, {})

	local v10 = module.useCallback(function()
		setState(false)
	end, {})

	local v11 = module.useCallback(function()
		setState2(false)
	end, {})

	local v12 = module.useCallback(function()
		if state3 then
			return
		end

		local v13 = p2.onLeaveSchool()

		if v13 == nil then
			return
		end

		setState3(true)
		setState2(false)

		v13:andThen(function()
			if not ref.current then
				return
			end

			if module11 then
				module7()
			else
				module8(false).clear()
			end

			v7()
		end):catch(function()
			if not ref.current then
				return
			end

			setState3(false)
			v5(module5.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v8.somethingWentWrong
			}))
		end)
	end, { state3, p2.onLeaveSchool, v5, v7, v8.somethingWentWrong })

	local v13 = module.useMemo(function()
		return {
			{
				id = "leave-school",
				text = v8.leaveSchool,
				onActivated = function()
					setState(false)
					setState2(true)
				end
			}
		}
	end, { v8.leaveSchool })

	local createElement = module.createElement
	local fragment = module.Fragment
	local createElement2 = module.createElement
	local v17 = {
		align = popoverAlign.End,
		items = v13,
		isOpen = state,
		onPressedOutside = v10,
		side = popoverSide.Bottom,
		size = inputSize.Medium,
		width = udim,
		LayoutOrder = 0
	}

	local v18 = if module10 then p2.LayoutOrder else nil
	v17.LayoutOrder = v18
	local v15 = {
		Menu = createElement2(menu, v17, {
			Anchor = module.createElement(iconButton, {
				icon = iconName.CircleThreeDotsHorizontal,
				size = iconSize.Medium,
				variant = buttonVariant.Utility,
				isDisabled = state3,
				onActivated = v9
			})
		}),
		ConfirmationDialog = 0
	}

	local v19 = if state2 then module.createElement(
		dialog.Root,
		{ disablePortal = false, hasBackdrop = true, size = dialogSize.Small },
		{
			Content = module.createElement(dialog.Content, { LayoutOrder = 1 }, {
				TitleAndBody = module.createElement(
					view,
					{ tag = "col size-full-0 auto-y padding-top-medium gap-xsmall" },
					{
						Title = module.createElement(text, {
							tag = "size-full-0 auto-y text-wrap text-align-x-left content-emphasis text-heading-small",
							Text = v8.removeSchoolTitle,
							LayoutOrder = 1
						}),
						Body = module.createElement(text, {
							tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-medium",
							Text = v8.removeSchoolBody,
							LayoutOrder = 2
						})
					}
				)
			}),
			Actions = module.createElement(dialog.Actions, {
				LayoutOrder = 2,
				orientation = orientation.Vertical,
				actions = {
					{
						text = v8.removeSchoolConfirm,
						variant = buttonVariant.Alert,
						onActivated = v12
					},
					{
						text = v8.cancel,
						variant = buttonVariant.Standard,
						onActivated = v11
					}
				}
			})
		}
	) else nil
	v15.ConfirmationDialog = v19
	return createElement(fragment, nil, v15)
end

return SchoolOverflowMenu
