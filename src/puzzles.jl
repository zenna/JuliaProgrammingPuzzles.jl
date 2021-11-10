function count(s::String,sub::String)
	reger = Regex(sub)
	l = [_ for _ in eachmatch(reger,s)]
	return length(l)
end