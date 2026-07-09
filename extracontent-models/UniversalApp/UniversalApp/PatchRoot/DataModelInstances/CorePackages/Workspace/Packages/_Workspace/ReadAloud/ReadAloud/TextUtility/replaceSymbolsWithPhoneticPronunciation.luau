local _ = {
	A = "ay",
	B = "be",
	C = "see",
	D = "dee",
	E = "ee",
	F = "ehff",
	G = "gee",
	H = "H",
	I = "aye",
	J = "jay",
	K = "kay",
	L = "",
	M = "",
	N = "",
	O = "",
	P = "",
	Q = "",
	R = "",
	S = "",
	T = "",
	U = "",
	V = "",
	W = "",
	X = "",
	Y = "",
	Z = ""
}

return function(s1: string) -- line: 30
	return (s1:gsub("%%", " percent"):gsub("(%d)%.(%d)", "%1 point %2"))
end
