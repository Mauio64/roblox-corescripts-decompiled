return {
	getDisplayName = function(p2)
		local titleForViewer = p2.titleForViewer

		if titleForViewer and titleForViewer ~= "" then
			return titleForViewer
		end

		return p2.title or ""
	end
}
