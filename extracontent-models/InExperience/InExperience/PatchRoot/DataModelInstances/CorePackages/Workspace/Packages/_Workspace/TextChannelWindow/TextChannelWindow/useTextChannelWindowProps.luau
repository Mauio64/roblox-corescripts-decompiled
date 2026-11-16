local parent = script.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local FFlagExpChatTextChannelWindowFontOverride = require(script.Parent.Flags.FFlagExpChatTextChannelWindowFontOverride)

local function resolveTarget(instance) -- 2 equivalent calls inferred from this helper
	local target = instance.Target
	return if target and target:IsA("TextChannel") then target else nil
end

local function resolveFontOverride(instance) -- 3 equivalent calls inferred from this helper
	if not FFlagExpChatTextChannelWindowFontOverride or instance.UseDefaultFont then
		return nil
	end

	return instance.FontFace
end

local function useTextChannelWindowProps(instance)
	local state, setState = React.useState(function()
		return resolveTarget(instance) -- inferred equivalent call
	end)

	local state2, setState2 = React.useState(function()
		return instance.BackgroundColor3
	end)

	local ref = React.useRef(state)

	useEventConnection(instance:GetPropertyChangedSignal("Target"), function()
		local target = resolveTarget(instance) -- inferred equivalent call
		ref.current = target

		setState(target)
	end, { instance })

	useEventConnection(instance:GetPropertyChangedSignal("BackgroundColor3"), function()
		setState2(instance.BackgroundColor3)
	end, { instance })
	local state3

	if FFlagExpChatTextChannelWindowFontOverride then
		local setState3
		state3, setState3 = React.useState(function()
			return resolveFontOverride(instance) -- inferred equivalent call
		end)

		useEventConnection(instance:GetPropertyChangedSignal("FontFace"), function()
			setState3(resolveFontOverride(instance)) -- inferred equivalent call
		end, { instance })

		useEventConnection(instance:GetPropertyChangedSignal("UseDefaultFont"), function()
			setState3(resolveFontOverride(instance)) -- inferred equivalent call
		end, { instance })
	end

	return { target = state, backgroundColor = state2, fontOverride = state3 }
end

return useTextChannelWindowProps
