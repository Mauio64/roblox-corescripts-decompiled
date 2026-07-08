local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local Signals = require(Parent.Signals)
local PeopleService = require(Parent.PeopleService)
local View = Foundation.View
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local useSignalState = SignalsReact.useSignalState
local v17 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v17.GetFFlagAddPeoplePageCardLayout
local GetFFlagNewPeoplePageIcons = v17.GetFFlagNewPeoplePageIcons

local function useIconName(p1, s1: string, b1: boolean) -- line: 45
	-- upvalues: React (copy)
	return React.useMemo(function() -- line: 46
		-- upvalues: p1 (copy), s1 (copy), b1 (copy)
		if p1.animatedIcon then
			return s1
		end

		if p1.icon then
			if p1.icon.off and p1.buttonState then
				if b1 then
					return p1.icon.off
				end

				return p1.icon.on
			end

			return p1.icon.on
		end

		return ""
	end, {
		s1,
		b1,
		p1.icon,
		p1.animatedIcon,
		p1.buttonState
	})
end
local function useTransparency(b2: boolean, p2) -- line: 63
	-- upvalues: React (copy)
	return React.useMemo(function() -- line: 64
		-- upvalues: b2 (copy), p2 (copy)
		if b2 then
			return p2.Color.Common.Shadow.Transparency
		end

		return nil
	end, { b2 })
end
local function useButtonSize(b3: boolean, p3) -- line: 73
	-- upvalues: React (copy), GetFFlagNewPeoplePageIcons (copy)
	return React.useMemo(function() -- line: 74
		-- upvalues: b3 (copy), GetFFlagNewPeoplePageIcons (copy), p3 (copy)
		if b3 then
			if GetFFlagNewPeoplePageIcons() then
				return UDim2.fromOffset(p3.Size.Size_1800 * 2, p3.Size.Size_1000)
			end

			return UDim2.new(0, p3.Size.Size_1800 * 2, 1, 0)
		end

		return UDim2.fromOffset(p3.Size.Size_1000, p3.Size.Size_1000)
	end, { b3 })
end
local function MemoizedIconElement(t1: {[any]: any}) -- line: 87
	-- upvalues: useTokens (copy), useSignalState (copy), Signals (copy), useIconName (copy), React (copy), IconButton (copy), IconSize (copy), ButtonVariant (copy), Icon (copy)
	local v34 = useTokens()
	local v35 = useSignalState(t1.animatedIcon or Signals.createSignal(""))
	local v36 = useSignalState(t1.buttonState or Signals.createSignal(false))
	local v37 = useSignalState(t1.isGrayedOut or Signals.createSignal(false))
	local v38 = useIconName(t1, v35, v36)
	local v39 = React.useMemo(function() -- line: 64
		-- upvalues: v37 (copy), v34 (copy)
		if v37 then
			return v34.Color.Common.Shadow.Transparency
		end

		return nil
	end, { v37 })
	local v40 = if not t1.isBuilderIcon then v39 else nil

	return React.useMemo(function() -- line: 110
		-- upvalues: v38 (copy), t1 (copy), React (copy), IconButton (copy), IconSize (copy), ButtonVariant (copy), v37 (copy), Icon (copy), v40 (copy)
		if not v38 or v38 == "" then
			return nil
		end

		if t1.isBuilderIcon then
			return (React.createElement(IconButton, {
				Selectable = false,
				icon = v38,
				size = IconSize.Medium,
				LayoutOrder = t1.LayoutOrder,
				variant = ButtonVariant.Utility,
				isDisabled = v37,
				onActivated = t1.onActivated,
				ref = t1.onMount
			}))
		end

		return (React.createElement(Icon, {
			name = v38,
			size = IconSize.Medium,
			LayoutOrder = t1.LayoutOrder,
			style = {
				Transparency = v40
			}
		}))
	end, {
		t1.isBuilderIcon,
		v38,
		t1.LayoutOrder,
		v37,
		t1.onActivated,
		t1.onMount,
		v40
	})
end
local function createTextElement(s2: string, b4: boolean?, p4, p5: ((...any) -> ...any), n1: number) -- line: 145
	-- upvalues: React (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy)
	if not s2 then
		return nil
	end

	return React.createElement(Button, {
		Selectable = false,
		text = s2,
		fillBehavior = FillBehavior.Fill,
		variant = if not b4 then p4 else ButtonVariant.Text,
		onActivated = p5,
		LayoutOrder = n1
	})
end
local function PersonButton(t2: {[any]: any}) -- line: 166
	-- upvalues: useTokens (copy), useSignalState (copy), Signals (copy), React (copy), GetFFlagNewPeoplePageIcons (copy), useCursor (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy), View (copy), GetFFlagAddPeoplePageCardLayout (copy), MemoizedIconElement (copy)
	local v47 = useTokens()
	local v48 = useSignalState(t2.isDisabled or Signals.createSignal(false))
	local v49 = useSignalState(type(t2.text) == "function" and t2.text or Signals.createSignal(t2.text))
	local v50 = useSignalState(type(t2.buttonVariant) == "function" and t2.buttonVariant or Signals.createSignal(t2.buttonVariant))
	local v51 = t2.text ~= nil
	local v52 = React.useMemo(function() -- line: 74
		-- upvalues: v51 (copy), GetFFlagNewPeoplePageIcons (copy), v47 (copy)
		if v51 then
			if GetFFlagNewPeoplePageIcons() then
				return UDim2.fromOffset(v47.Size.Size_1800 * 2, v47.Size.Size_1000)
			end

			return UDim2.new(0, v47.Size.Size_1800 * 2, 1, 0)
		end

		return UDim2.fromOffset(v47.Size.Size_1000, v47.Size.Size_1000)
	end, { v51 })
	local v53 = useCursor({
		radius = UDim.new(0, v47.Radius.Medium),
		offset = v47.Size.Size_150,
		borderWidth = v47.Stroke.Thicker
	})
	local onActivated = t2.onActivated
	local v55 = if v49 then React.createElement(Button, {
		Selectable = false,
		LayoutOrder = 2,
		text = v49,
		fillBehavior = FillBehavior.Fill,
		variant = if not v48 then v50 else ButtonVariant.Text,
		onActivated = onActivated
	}) else nil

	return React.createElement(View, {
		tag = if not GetFFlagAddPeoplePageCardLayout() then {
			["radius-medium row align-y-center align-x-center"] = t2.text ~= nil,
			["radius-medium row align-y-center align-x-center bg-action-standard"] = t2.text == nil
		} else {
			["radius-medium row align-y-center align-x-center"] = true,
			["bg-action-standard"] = not t2.text and not t2.isBackgroundTransparent
		},
		Size = v52,
		LayoutOrder = t2.LayoutOrder,
		onActivated = t2.onActivated,
		isDisabled = v48,
		selection = {
			SelectionImageObject = v53
		},
		ref = t2.onMount
	}, {
		Icon = React.createElement(MemoizedIconElement, {
			icon = t2.icon,
			animatedIcon = t2.animatedIcon,
			buttonState = t2.buttonState,
			LayoutOrder = t2.LayoutOrder,
			isGrayedOut = t2.isGrayedOut,
			isBuilderIcon = t2.isBuilderIcon,
			onActivated = t2.onActivated,
			onMount = t2.onMount
		}),
		Text = v55
	})
end

return PersonButton
