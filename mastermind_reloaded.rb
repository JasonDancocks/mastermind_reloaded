def caesar_cipher(text, shift) 
	unless text.nil? || shift.nil?
		if shift > 26
			shift = shift % 26
		end
		letters = text.split("")
		letters.map! do |w|
			if w =~ /[A-Za-z]/
				if( w.ord + shift > 122)
					i = (w.ord + shift) - 123  
					w = 97 + i
				else
					w = w.ord + shift
				end			
				w = w.chr.downcase
			else
				w 
			end
		end
		letters.join("")
	end
end
