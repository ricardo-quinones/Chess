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

  def initialize(salary, title)
    super
    @employees = []
  end

  def add_employee(*employee)
    employee.each do |emp|
      emp.manager = self
      @employees << employee
    end
  end

  def bonus(multiplier)
    sub_employee_sal = 0
    @employees.each do |employee|
      sub_employee_sal += employee.salary
    end
    sub_employee_sal * multiplier
  end
end

seth = Employee.new(80000, "Dev slave")
ricky = Employee.new(85000, "Dev underling")
sid = Manager.new(100000, "Dev superstar")
sid.add_employee(seth, sid)

p seth.salary
seth.bonus(0.01)
sid.employees.each do |emp|
  p emp
end
# p sid
# p seth.bonus(0.10)
# p sid.bonus(0.10)
# p ricky.bonus(0.10)