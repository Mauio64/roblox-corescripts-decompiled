return {
	getDisplayName = function(p)
		local titleForViewer = p.titleForViewer

		if titleForViewer and titleForViewer ~= "" then
			return titleForViewer
		end

		return p.title or ""
	end
}
