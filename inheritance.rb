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

  def add_employee(*employee)
    employee.each do |emp|
      emp.manager = self
      @employees << emp
    end
  end

  def sub_salaries
    total_salaries = 0
    self.employees.each do |emp|
      total_salaries += emp.salary
      p emp.class
      total_salaries += emp.sub_salaries if emp.class == Manager
    end
    total_salaries
  end

  def bonus(multiplier)
    sub_employee_sal = 0
    @employees.each do |emp|
      sub_employee_sal += emp.salary

    end
    sub_employee_sal * multiplier
  end
end

seth = Manager.new(80000, "Dev slave")
ricky = Employee.new(85000, "Dev underling")
sid = Manager.new(100000, "Dev superstar")
seth.add_employee(ricky)
sid.add_employee(seth)

# p seth.salary
# seth.bonus(0.01)
# sid.employees.each do |emp|
#   p emp
# end
# p sid
# p seth.bonus(0.01)
# p ricky.bonus(0.01)
# p sid.bonus(0.01)

p sid.sub_salaries