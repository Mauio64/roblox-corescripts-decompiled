local ParentParent = script.Parent.Parent
local CoreGui = game:GetService("CoreGui")
local Constants = require(ParentParent.Constants)
local v4 = game:DefineFastFlag("CapturesRecursiveCoreUIRemoval", false)

return function() -- line: 8
	-- upvalues: Constants (copy), v4 (copy), CoreGui (copy)
	local t1 = {}

	local function shouldRemoveUI(p1) -- line: 11
		-- upvalues: Constants (copy)
		if not p1:IsA("LayerCollector") then
			return false
		end

		if p1:IsA("BillboardGui") then
			return false
		end

		if not p1.Enabled then
			return false
		end

		if p1.Name == Constants.OverlayName then
			return false
		end

		return true
	end

	if v4 then
		local function searchInstance(p2) -- line: 34
			-- upvalues: Constants (copy), t1 (copy), searchInstance (copy)
			if not p2:IsA("Folder") and not p2:IsA("CoreGui") then
				if if p2:IsA("LayerCollector") then not p2:IsA("BillboardGui") and if p2.Enabled then p2.Name ~= Constants.OverlayName else false else false then
					p2.Enabled = false
					table.insert(t1, p2)
				end

				return
			end

			for _, child in p2:GetChildren() do
				searchInstance(child)
			end
		end

		searchInstance(CoreGui)
	else
		for _, child in CoreGui:GetChildren() do
			if child:IsA("Folder") then
				for _, child2 in child:GetChildren() do
					if if child2:IsA("LayerCollector") then not child2:IsA("BillboardGui") and if child2.Enabled then child2.Name ~= Constants.OverlayName else false else false then
						child2.Enabled = false
						table.insert(t1, child2)
					end
				end
			end

			if if child:IsA("LayerCollector") then not child:IsA("BillboardGui") and if child.Enabled then child.Name ~= Constants.OverlayName else false else false then
				child.Enabled = false
				table.insert(t1, child)
			end
		end
	end

	local function restoreCoreUI() -- line: 70
		-- upvalues: t1 (copy)
		for _, v18 in t1 do
			v18.Enabled = true
		end
	end

	return restoreCoreUI
end
