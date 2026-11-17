local GuiService = game:GetService("GuiService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local useBinding = React.useBinding
local useContext = React.useContext
local useEffect = React.useEffect

local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local Responsive = require(parent.Responsive)
local useOrientation = Responsive.useOrientation

local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local getFFlagAppChatInExperienceTabBarAdjustment = require(AppChat.Flags.getFFlagAppChatInExperienceTabBarAdjustment)

local function useParentContainerExtents()
	local parentContainer = useContext(ParentContainerContext).getParentContainer()
	local v = useLayerCollector()
	local v2

	if not getFFlagAppChatInExperienceTabBarAdjustment() then
		v2 = useOrientation()
	end

	local v3

	if parentContainer then
		v3 = parentContainer.AbsoluteSize
	else
		v3 = Vector2.zero
	end

	local v4, v5 = useBinding(v3)
	local v6

	if parentContainer then
		v6 = parentContainer.AbsolutePosition
	else
		v6 = Vector2.zero
	end

	local v7, v8 = useBinding(v6)
	local v9

	if getFFlagAppChatInExperienceTabBarAdjustment() then
		v9 = nil
	else
		v9 = v2 == Responsive.Keys.Landscape
	end

	useEffect(function()
		if not parentContainer then
			return function() end
		end

		local function fn(p, zero, p2) -- 2 equivalent calls inferred from this helper
			return Vector2.new(math.clamp(p.X, zero.X, p2.X), (math.clamp(p.Y, zero.Y, p2.Y)))
		end

		local function onSafeZoneOffsetsChanged()
			local absoluteSize = parentContainer.AbsoluteSize
			local absolutePosition = parentContainer.AbsolutePosition
			local absoluteSize2 = v.absoluteSize
			local v10 = Vector2.zero

			if not getFFlagAppChatInExperienceTabBarAdjustment() and v9 then
				v10 = Vector2.new(0, GuiService:GetSafeZoneOffsets().bottom)
			end

			local v11 = absoluteSize2 - v10

			local v12 = fn(absolutePosition, Vector2.zero, v11) -- inferred equivalent call

			local v13 = fn(absoluteSize, Vector2.zero, v11 - v12) -- inferred equivalent call

			v5(v13)
			v8(v12)
		end

		local absoluteSizeChangedConnection = parentContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(onSafeZoneOffsetsChanged)

		local absolutePositionChangedConnection = parentContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(onSafeZoneOffsetsChanged)
		local safeZoneOffsetsChangedConnection

		if getFFlagAppChatInExperienceTabBarAdjustment() then
			safeZoneOffsetsChangedConnection = nil
		else
			safeZoneOffsetsChangedConnection = GuiService.SafeZoneOffsetsChanged:Connect(onSafeZoneOffsetsChanged)
		end

		onSafeZoneOffsetsChanged()

		return function()
			if absoluteSizeChangedConnection and absoluteSizeChangedConnection.Connected then
				absoluteSizeChangedConnection:Disconnect()
			end

			if absolutePositionChangedConnection and absolutePositionChangedConnection.Connected then
				absolutePositionChangedConnection:Disconnect()
			end

			if
				not getFFlagAppChatInExperienceTabBarAdjustment()
				and safeZoneOffsetsChangedConnection
				and safeZoneOffsetsChangedConnection.Connected
			then
				safeZoneOffsetsChangedConnection:Disconnect()
			end
		end
	end, { parentContainer, v5, v8, v.absoluteSize, v9 })

	return v4, v7
end

return useParentContainerExtents
