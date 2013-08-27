class Employee

  attr_accessor :manager, :salary

  def initialize(salary, title)
    @salary = salary
    @title = title
    @manager = nil
  end

  def salary=(value)
    @salary = value
  end

  def bonus(mulitiplier)
    @salary * mulitiplier
  end
end

class Manager < Employee

  attr_accessor :employees

  def initialize(salary, title)
    super
    @employees = []
  end

  def add_employees(*employee)
    employee.each do |emp|
      emp.manager = self
      @employees << emp
    end
  end

  def sub_salaries
    total_salaries = 0
    self.employees.each do |emp|
      total_salaries += emp.salary
      total_salaries += emp.sub_salaries if emp.class == Manager
    end
    total_salaries
  end

  def bonus(multiplier)
    self.sub_salaries * multiplier
  end
end
