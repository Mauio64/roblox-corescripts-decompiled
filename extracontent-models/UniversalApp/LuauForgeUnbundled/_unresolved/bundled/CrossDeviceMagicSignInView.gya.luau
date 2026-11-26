local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjJ")
local module3 = require("@luauforge/bundled/ggL")
local module4 = require("@luauforge/bundled/gyb")
local module5 = require("@luauforge/bundled/gyc")

local backgroundFill = module3.Components.BackgroundFill
local image = module2.Image
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens

local module6 = require("@luauforge/bundled/gyd")
require("@luauforge/bundled/gye")

local vector2 = Vector2.new(158, 116)
local vector2_2 = Vector2.new(965, 488)

local vector2_3 = Vector2.new(vector2.X + vector2_2.X, 676)

local function getFitScale(absoluteSize, scale, data)
	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return 1
	end

	local v5 = Vector2.new(1280, 720) * scale
	local v6 = absoluteSize / 2
	local v7 = v5 / 2 - vector2 * scale
	local v8 = vector2_3 * scale - v5 / 2
	return (math.min(
		absoluteSize.X / v5.X,
		absoluteSize.Y / v5.Y,
		(v6.X - data.left) / v7.X,
		(v6.Y - data.top) / v7.Y,
		(v6.X - data.right) / v8.X,
		(v6.Y - data.bottom) / v8.Y
	))
end

local function linkSwitchAccount(p2, p3, p4)
	if type(p2.type) == "function" then
		return module.cloneElement(p2, { nextSelectionUp = p3, buttonRef = p4 })
	end

	return p2
end

local function renderNavigation(rows, scale, defaultRef, p2)
	local flag = false
	local children = {}

	for k, item in rows do
		if item.kind == "divider" then
			children[item.key] = module.createElement(view, {
				LayoutOrder = k,
				Size = UDim2.new(1, 0, 0, 17 * scale),
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Line = module.createElement(view, {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, scale),
					tag = "bg-shift-300"
				})
			})
		else
			local v5 = if not flag then defaultRef else nil
			local switchButton

			if item.key == "CreateAccount" then
				v5 = p2.bottomControlRef
				switchButton = p2.switchButton
			end

			children[item.key] = module.createElement(module6, {
				icon = item.icon,
				text = item.text,
				layoutOrder = k,
				onActivated = item.onActivated,
				testId = item.key,
				selectionRef = v5,
				nextSelectionDown = switchButton
			})
			flag = true
		end
	end

	return children
end

local function CrossDeviceMagicSignInView(props)
	local v5 = useTokens()
	local scale = v5.Config.UI.Scale
	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)
	local v6 = {
		bottomControlRef = module.useCallback(function(current)
			ref.current = current
		end, {}),
		switchButton = ref2
	}

	local v7 = module5.useSignalState(function(p2)
		return module4.GetDisplayStore(p2).getDeviceSafePadding(p2)
	end)

	local v8, v9 = module.useBinding(1)

	local v10 = module.useCallback(function(p2)
		v9(getFitScale(p2.AbsoluteSize, scale, v7))
	end, { scale, v7 })

	local vector2_4 = Vector2.new(1280 * scale, 720 * scale)
	local card = props.card
	local v11 = if props.renderQrPane ~= nil then props.renderQrPane(nil) else nil

	local createElement = module.createElement
	local v13 = {
		Position = UDim2.fromOffset(-v7.left, -v7.top),
		Size = UDim2.new(1, v7.left + v7.right, 1, v7.top + v7.bottom),
		onAbsoluteSizeChanged = v10,
		ref = props.containerRef,
		tag = "clip",
		testId = "CrossDeviceMagicSignIn"
	}

	local v14 = {
		Background = module.createElement(view, { ZIndex = 1, tag = "size-full" }, {
			Art = module.createElement(backgroundFill, {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg"
			})
		}),
		Scrim = module.createElement(view, {
			ZIndex = 2,
			backgroundStyle = v5.Color.Common.Backdrop,
			tag = "size-full"
		}),
		Canvas = 0
	}

	local createElement2 = module.createElement
	local v16 = {
		Size = UDim2.fromOffset(vector2_4.X, vector2_4.Y),
		tag = "position-center-center anchor-center-center",
		ZIndex = 3,
		scale = v8,
		testId = "CrossDeviceMagicSignInCanvas"
	}

	local createElement3 = module.createElement
	local v19 = {
		Position = UDim2.fromOffset(vector2.X * scale, vector2.Y * scale),
		Size = UDim2.fromOffset(vector2_2.X * scale, vector2_2.Y * scale),
		tag = "radius-large clip bg-surface-0",
		testId = "CrossDeviceMagicSignInCard"
	}

	local v20 = {
		LeftColumn = module.createElement(view, {
			Position = UDim2.fromOffset(40 * scale, 40 * scale),
			Size = UDim2.fromOffset(402 * scale, 408 * scale)
		}, {
			Wordmark = module.createElement(image, {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png",
				ScaleType = Enum.ScaleType.Stretch,
				Size = UDim2.fromOffset(140 * scale, 25.81 * scale),
				imageStyle = v5.Color.Content.Emphasis,
				testId = "CrossDeviceMagicSignInWordmark"
			}),
			Title = module.createElement(text, {
				Position = UDim2.fromOffset(0, 88.81 * scale),
				Size = UDim2.new(1, 0, 0, 34 * scale),
				Text = card.title,
				tag = "text-heading-large text-align-x-left text-truncate-end content-emphasis"
			}),
			Body = module.createElement(text, {
				Position = UDim2.fromOffset(0, 126.81 * scale),
				Size = UDim2.new(1, 0, 0, 22 * scale),
				Text = card.body,
				tag = "text-body-large text-align-x-left text-truncate-end content-default"
			}),
			Navigation = module.createElement(view, {
				Position = UDim2.fromOffset(0, 176.81 * scale),
				Size = UDim2.new(1, 0, 0, 173 * scale),
				tag = "col gap-xsmall"
			}, renderNavigation(card.rows, scale, props.defaultRef, v6))
		}),
		Divider = 0,
		QRColumn = 0
	}

	local v21 = if v11 ~= nil then module.createElement(view, {
		Position = UDim2.fromOffset(482 * scale, 40 * scale),
		Size = UDim2.fromOffset(scale, 408 * scale),
		tag = "bg-shift-300"
	}) else nil
	v20.Divider = v21

	local v22 = if v11 ~= nil then module.createElement(view, {
		Position = UDim2.fromOffset(523 * scale, 40 * scale),
		Size = UDim2.fromOffset(402 * scale, 408 * scale),
		testId = "CrossDeviceMagicSignInQRColumn"
	}, { Pane = v11 }) else nil
	v20.QRColumn = v22
	local v17 = { Card = createElement3(view, v19, v20), SwitchAccount = 0 }
	local v23

	if props.switchAccount ~= nil then
		local createElement4 = module.createElement
		local v25 = {
			Position = UDim2.fromOffset(0, 628 * scale),
			Size = UDim2.new(1, 0, 0, 48 * scale),
			tag = "row align-x-center align-y-center"
		}

		local switchAccount = props.switchAccount

		if type(switchAccount.type) == "function" then
			switchAccount = module.cloneElement(switchAccount, {
				nextSelectionUp = ref,
				buttonRef = ref2
			})
		end

		v23 = createElement4(view, v25, { Content = switchAccount })
	end

	v17.SwitchAccount = v23
	v14.Canvas = createElement2(view, v16, v17)
	return createElement(view, v13, v14)
end

return CrossDeviceMagicSignInView
