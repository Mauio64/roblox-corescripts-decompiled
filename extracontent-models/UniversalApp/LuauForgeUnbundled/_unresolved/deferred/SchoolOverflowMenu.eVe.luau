local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eUP")
local module4 = require("@luauforge/deferred/egV")
local module5 = require("@luauforge/deferred/eVf")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module6 = require("@luauforge/deferred/ehb")
local module7 = require("@luauforge/deferred/eVg")
local module8 = require("@luauforge/deferred/ehh")
local module9 = require("@luauforge/deferred/ehP")
local module10 = require("@luauforge/deferred/eVn")
local module11 = require("@luauforge/deferred/eVm")

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
	local v6 = module9((useNavigation()))
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(false)
	local ref = module.useRef(true)

	module.useEffect(function()
		return function()
			ref.current = false
		end
	end, {})

	local v7 = useLocalization({
		leaveSchool = module6.ActionLeaveSchool,
		cancel = module6.ActionCancel,
		removeSchoolTitle = module6.RemoveSchoolTitle,
		removeSchoolBody = module6.RemoveSchoolBody,
		removeSchoolConfirm = module6.RemoveSchoolConfirm,
		somethingWentWrong = module6.SomethingWentWrong
	})

	local v8 = module.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, {})

	local v9 = module.useCallback(function()
		setState(false)
	end, {})

	local v10 = module.useCallback(function()
		setState2(false)
	end, {})

	local v11 = module.useCallback(function()
		if state3 then
			return
		end

		local v12 = p2.onLeaveSchool()

		if v12 == nil then
			return
		end

		setState3(true)
		setState2(false)

		v12:andThen(function()
			if not ref.current then
				return
			end

			if module11 then
				module7()
			else
				module8(false).clear()
			end

			v6()
		end):catch(function()
			if not ref.current then
				return
			end

			setState3(false)
			v5(module5.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v7.somethingWentWrong
			}))
		end)
	end, { state3, p2.onLeaveSchool, v5, v6, v7.somethingWentWrong })

	local v12 = module.useMemo(function()
		return {
			{
				id = "leave-school",
				text = v7.leaveSchool,
				onActivated = function()
					setState(false)
					setState2(true)
				end
			}
		}
	end, { v7.leaveSchool })

	local createElement = module.createElement
	local fragment = module.Fragment
	local createElement2 = module.createElement
	local v16 = {
		align = popoverAlign.End,
		items = v12,
		isOpen = state,
		onPressedOutside = v9,
		side = popoverSide.Bottom,
		size = inputSize.Medium,
		width = udim,
		LayoutOrder = 0
	}

	local v17 = if module10 then p2.LayoutOrder else nil
	v16.LayoutOrder = v17
	local v14 = {
		Menu = createElement2(menu, v16, {
			Anchor = module.createElement(iconButton, {
				icon = iconName.CircleThreeDotsHorizontal,
				size = iconSize.Medium,
				variant = buttonVariant.Utility,
				isDisabled = state3,
				onActivated = v8
			})
		}),
		ConfirmationDialog = 0
	}

	local v18 = if state2 then module.createElement(
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
							Text = v7.removeSchoolTitle,
							LayoutOrder = 1
						}),
						Body = module.createElement(text, {
							tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-medium",
							Text = v7.removeSchoolBody,
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
						text = v7.removeSchoolConfirm,
						variant = buttonVariant.Alert,
						onActivated = v11
					},
					{
						text = v7.cancel,
						variant = buttonVariant.Standard,
						onActivated = v10
					}
				}
			})
		}
	) else nil
	v14.ConfirmationDialog = v18
	return createElement(fragment, nil, v14)
end

return SchoolOverflowMenu
