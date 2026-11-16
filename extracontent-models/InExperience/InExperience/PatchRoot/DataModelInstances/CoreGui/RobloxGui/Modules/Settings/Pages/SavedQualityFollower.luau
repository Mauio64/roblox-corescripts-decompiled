local SavedQualityFollower = {}
SavedQualityFollower.__index = SavedQualityFollower

function SavedQualityFollower.new(enabler, slider)
	return (setmetatable(
		{ _enabler = enabler, _slider = slider, _isShowing = false, _showCount = 0 },
		SavedQualityFollower
	))
end

function SavedQualityFollower:isShowing()
	return self._isShowing
end

function SavedQualityFollower:show(p)
	local v = p == Enum.SavedQualitySetting.Automatic
	local v2 = v and 1 or 2
	local v3 = self._enabler:GetSelectedIndex() ~= v2
	local v4 = not v and self._slider:GetValue() ~= p.Value

	if not (v3 or v4) then
		return
	end

	self._isShowing = true
	self._showCount += 1
	local showCount = self._showCount

	if v3 then
		self._enabler:SetSelectionIndex(v2)
	end

	if v4 then
		self._slider:SetValue(p.Value)
	end

	task.defer(function()
		if self._showCount == showCount then
			self._isShowing = false
		end
	end)
end

return SavedQualityFollower
