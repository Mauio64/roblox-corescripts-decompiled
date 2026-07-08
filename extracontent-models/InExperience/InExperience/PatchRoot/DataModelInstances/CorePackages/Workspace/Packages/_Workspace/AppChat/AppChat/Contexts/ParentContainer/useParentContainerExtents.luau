local GuiService = game:GetService("GuiService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useBinding = React.useBinding
local useContext = React.useContext
local useEffect = React.useEffect
local useLayerCollector = require(AppChatParent.UIBlox).Core.Layout.LayerCollector.useLayerCollector
local Responsive = require(AppChatParent.Responsive)
local useOrientation = Responsive.useOrientation
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local getFFlagAppChatInExperienceTabBarAdjustment = require(AppChat.Flags.getFFlagAppChatInExperienceTabBarAdjustment)

local function useParentContainerExtents() -- line: 22
	-- upvalues: useContext (copy), ParentContainerContext (copy), useLayerCollector (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy), useOrientation (copy), useBinding (copy), Responsive (copy), useEffect (copy), GuiService (copy)
	local v14 = useContext(ParentContainerContext).getParentContainer()
	local v15 = useLayerCollector()
	local v16 = if getFFlagAppChatInExperienceTabBarAdjustment() then nil else useOrientation()
	local v17, v18 = useBinding(if not v14 then Vector2.zero else v14.AbsoluteSize)
	local v19, v20 = useBinding(if not v14 then Vector2.zero else v14.AbsolutePosition)
	local v21 = if getFFlagAppChatInExperienceTabBarAdjustment() then nil else v16 == Responsive.Keys.Landscape

	useEffect(function() -- line: 37
		-- upvalues: v14 (copy), v15 (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy), v21 (copy), GuiService (copy), v18 (copy), v20 (copy)
		if v14 then
			local connection = nil

			local function v23() -- line: 45
				-- upvalues: v14 (copy), v15 (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy), v21 (copy), GuiService (copy), v18 (copy), v20 (copy)
				local AbsoluteSize = v14.AbsoluteSize
				local AbsolutePosition = v14.AbsolutePosition
				local absoluteSize = v15.absoluteSize
				local zero = Vector2.zero

				if not getFFlagAppChatInExperienceTabBarAdjustment() and v21 then
					zero = Vector2.new(0, GuiService:GetSafeZoneOffsets().bottom)
				end

				local v33 = absoluteSize - zero
				local zero2 = Vector2.zero
				local vector2 = Vector2.new(math.clamp(AbsolutePosition.X, zero2.X, v33.X), (math.clamp(AbsolutePosition.Y, zero2.Y, v33.Y)))
				local zero3 = Vector2.zero
				local v37 = v33 - vector2
				local vector2_2 = Vector2.new(math.clamp(AbsoluteSize.X, zero3.X, v37.X), (math.clamp(AbsoluteSize.Y, zero3.Y, v37.Y)))

				v18(vector2_2)
				v20(vector2)
			end

			local connection2 = v14:GetPropertyChangedSignal("AbsoluteSize"):Connect(v23)
			local connection3 = v14:GetPropertyChangedSignal("AbsolutePosition"):Connect(v23)

			if not getFFlagAppChatInExperienceTabBarAdjustment() then
				connection = GuiService.SafeZoneOffsetsChanged:Connect(v23)
			end

			v23()

			return function() -- line: 85
				-- upvalues: connection2 (ref), connection3 (ref), getFFlagAppChatInExperienceTabBarAdjustment (copy), connection (ref)
				if connection2 and connection2.Connected then
					connection2:Disconnect()
				end

				if connection3 and connection3.Connected then
					connection3:Disconnect()
				end

				if not getFFlagAppChatInExperienceTabBarAdjustment() and connection and connection.Connected then
					connection:Disconnect()
				end
			end
		end

		return function() -- line: 100
		end
	end, {
		v14,
		v18,
		v20,
		v15.absoluteSize,
		v21
	})

	return v17, v19
end

return useParentContainerExtents
