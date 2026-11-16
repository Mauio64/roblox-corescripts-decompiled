local parent = script.Parent.Parent

local CoreGui = game:GetService("CoreGui")

local Constants = require(parent.Constants)
local defineFastFlag = game:DefineFastFlag("CapturesRecursiveCoreUIRemoval", false)

return function()
	local v = {}

	local function shouldRemoveUI(instance): boolean
		if not instance:IsA("LayerCollector") or instance:IsA("BillboardGui") then
			return false
		end

		if instance.Enabled then
			return instance.Name ~= Constants.OverlayName
		end

		return false
	end

	if defineFastFlag then
		local function searchInstance(CoreGui2)
			if CoreGui2:IsA("Folder") or CoreGui2:IsA("CoreGui") then
				for _, child in CoreGui2:GetChildren() do
					searchInstance(child)
				end
			else
				local v2

				if CoreGui2:IsA("LayerCollector") and not CoreGui2:IsA("BillboardGui") and CoreGui2.Enabled then
					v2 = CoreGui2.Name ~= Constants.OverlayName
				else
					v2 = false
				end

				if v2 then
					CoreGui2.Enabled = false
					table.insert(v, CoreGui2)
				end
			end
		end

		searchInstance(CoreGui)
	else
		for _, child in CoreGui:GetChildren() do
			if child:IsA("Folder") then
				for _, child2 in child:GetChildren() do
					local v2

					if child2:IsA("LayerCollector") and not child2:IsA("BillboardGui") and child2.Enabled then
						v2 = child2.Name ~= Constants.OverlayName
					else
						v2 = false
					end

					if not v2 then
						continue
					end

					child2.Enabled = false
					table.insert(v, child2)
				end
			end

			local v2

			if child:IsA("LayerCollector") and not child:IsA("BillboardGui") and child.Enabled then
				v2 = child.Name ~= Constants.OverlayName
			else
				v2 = false
			end

			if not v2 then
				continue
			end

			child.Enabled = false
			table.insert(v, child)
		end
	end

	local function restoreCoreUI()
		for _, v2 in v do
			v2.Enabled = true
		end
	end

	return restoreCoreUI
end
