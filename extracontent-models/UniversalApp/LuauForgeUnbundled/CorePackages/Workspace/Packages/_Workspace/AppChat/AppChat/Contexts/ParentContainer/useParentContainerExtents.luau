local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useBinding = React.useBinding
local useContext = React.useContext
local useEffect = React.useEffect

local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Layout.LayerCollector.useLayerCollector

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local useOrientation = Responsive.useOrientation

local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")
local getFFlagAppChatInExperienceTabBarAdjustment = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatInExperienceTabBarAdjustment")

local function useParentContainerExtents()
	local parentContainer = useContext(ParentContainerContext).getParentContainer()
	local v5 = useLayerCollector()
	local v6 = if not getFFlagAppChatInExperienceTabBarAdjustment() then useOrientation() else nil

	local v8 = if parentContainer then parentContainer.AbsoluteSize else Vector2.zero
	local v9, v10 = useBinding(v8)

	local v12 = if parentContainer then parentContainer.AbsolutePosition else Vector2.zero
	local v13, v14 = useBinding(v12)

	local v15 = if not getFFlagAppChatInExperienceTabBarAdjustment() then v6 == Responsive.Keys.Landscape else nil

	useEffect(function()
		if not parentContainer then
			return function() end
		end

		local function onSafeZoneOffsetsChanged()
			local absoluteSize = parentContainer.AbsoluteSize
			local absolutePosition = parentContainer.AbsolutePosition
			local absoluteSize2 = v5.absoluteSize
			local v16 = Vector2.zero

			if not getFFlagAppChatInExperienceTabBarAdjustment() and v15 then
				v16 = Vector2.new(0, GuiService:GetSafeZoneOffsets().bottom)
			end

			local v17 = absoluteSize2 - v16

			local zero = Vector2.zero
			local vector2 = Vector2.new(
				math.clamp(absolutePosition.X, zero.X, v17.X),
				(math.clamp(absolutePosition.Y, zero.Y, v17.Y))
			)

			local zero2 = Vector2.zero
			local v18 = v17 - vector2
			v10((Vector2.new(
				math.clamp(absoluteSize.X, zero2.X, v18.X),
				(math.clamp(absoluteSize.Y, zero2.Y, v18.Y))
			)))
			v14(vector2)
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
	end, { parentContainer, v10, v14, v5.absoluteSize, v15 })

	return v9, v13
end

return useParentContainerExtents
