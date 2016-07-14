class Person
	attr_accessor :first, :last, :params

	def initialize(attributes = {})
		@first = attributes[:first]
		@last = attributes[:last]
		@params = attributes[:params]
	end

	def name
		"#{@first} <#{@last}>"
	end

	def params
		"#{@params}"
	end
end