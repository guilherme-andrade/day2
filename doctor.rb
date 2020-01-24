require 'sqlite3'
require 'pry-byebug'

DB = SQLite3::Database.new('./doctors.sqlite')
DB.results_as_hash = true

class Doctor
	attr_accessor :age, :name, :specialty
	attr_reader :id
	# Instance Methods


	# TODO: initializes an instance of the Doctor class
	
	# > Doctor.new({
	# * 	name: 'Mehmet',
	# * 	age: 46,
	# * 	specialty: 'General'
	# * })
	def initialize(doctor_attributes)
	  @id = doctor_attributes['id'] || doctor_attributes[:id]
	  @name = doctor_attributes['name'] || doctor_attributes[:name]
	  @age = doctor_attributes['age'] || doctor_attributes[:age]
	  @specialty = doctor_attributes['specialty'] || doctor_attributes[:specialty]
	end


	# TODO: updates the doctor in the doctors table
	
	# > doctor = Doctor.find(1)
	# > doctor.update({ specialty: 'Physician', age: 45 })
	def update(attributes)
		attributes.each do |attr_name, attr_value|
			DB.execute("UPDATE doctors SET #{attr_name} = ? WHERE id = ?", attr_value, id)
			instance_variable_set("@#{attr_name}", attr_value)
		end
		self
	end


	# TODO: removes the doctor from the doctors table
	
	# > doctor = Doctor.find(1)
	# > doctor.destroy
	def destroy
		DB.execute("DELETE FROM doctors WHERE id = ?", @id)
	end


	# TODO: saves the doctor to the database

	# > doctor = Doctor.new({
	# * 	first_name: 'Mehmet',
	# * 	last_name: 'Oz',
	# * 	specialty: 'General'
	# * })
	# > doctor.save
	def save
		DB.execute('INSERT INTO doctors (name, age, specialty) VALUES (?, ?, ?)', name, age, specialty)
		@id = DB.last_insert_row_id unless @id
		self
	end



	# Class Methods

	# TODO: returns an array of doctors

	# > Doctor.all
	def self.all
		DB.execute('SELECT * FROM doctors;').map { |result| self.new(result) }
	end


	# TODO: saves a new entry in doctors table with doctor_attributes


	# > Doctor.create({
	# * 	name: 'Mehmet',
	# * 	age: 'Oz',
	# * 	specialty: 'General'
	# * })
	def self.create(attributes)
		# 1. initialize - at this point we don't know an ID
		doctor = self.new(attributes)
		# 2. save
		doctor.save
	end


	# TODO: returns doctor with id = 1

	# > Doctor.find(1)
	def self.find(id) # id = '1; DESTROY FROM doctors;'
		# SELECT * FROM doctors WHERE id = 2
		result = DB.execute("SELECT * FROM doctors WHERE id = ?", id).first
		return unless result # if result is nil, leave the method

		self.new(result)
	end
end
