# Use this file to import the sales information into the
# the database.

require "pg"
require 'csv'
require 'pry'

system 'psql korning < schema.sql'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

@sales = []
@frequency = []
@employees = []
@customers = []
CSV.foreach("sales.csv", headers: true, header_converters: :symbol) do |row|
  sale = row.to_hash
  @sales << sale
end

@sales.each do |sale|

  unless @frequency.include?(sale[:invoice_frequency])
    @frequency << sale[:invoice_frequency]
  end

  unless @employees.include?(sale[:employee])
    @employees << sale[:employee]
  end

  unless @customers.include?(sale[:customer_and_account_no])
    @customers << sale[:customer_and_account_no]
  end
end


@frequency.each do |freq|
  db_connection do |conn|
      conn.exec_params("INSERT INTO frequency (frequency) VALUES ($1);", [freq])
  end
end

@employee_info = []

@employees.each do |emp|
  emps = emp.split(" ")

  employee = {}
  employee[:name] = emps[0, 2].join(' ')
  employee[:email] = emps[-1].gsub(/[()]/, '')
  @employee_info << employee
end

@employee_info.each do |emp|
  db_connection do |conn|
      conn.exec_params("INSERT INTO employee (name, email) VALUES ($1, $2);", [emp[:name], emp[:email]])
  end
end

@customer_info = []

@customers.each do |cust|
  custs = cust.split(" ")

  customer = {}
  customer[:name] = custs[0]
  customer[:account] = custs[-1].gsub(/[()]/, '')
  @customer_info << customer
end

@customer_info.each do |cust|
  db_connection do |conn|
      conn.exec_params("INSERT INTO customer (name, account) VALUES ($1, $2);", [cust[:name], cust[:account]])
  end
end

@sales.each do |sale|
  db_connection do |conn|
    conn.exec_params("INSERT INTO sales (product, date, amount, units, inv_num) VALUES ($1, $2, $3, $4, $5);", [sale[:product_name], sale[:sale_date], sale[:sale_amount], sale[:units_sold], sale[:invoice_no]])

    if sale[:employee].include?("Clancy Wiggum")
      conn.exec_params("INSERT INTO sales (emp_id) VALUES ($1);", [1])
    elsif sale[:employee].include?("Ricky Bobby")
      conn.exec_params("INSERT INTO sales (emp_id) VALUES ($1);", [2])
    elsif sale[:employee].include?("Bob Lob")
      conn.exec_params("INSERT INTO sales (emp_id) VALUES ($1);", [3])
    elsif sale[:employee].include?("Willie Groundskeeper")
      conn.exec_params("INSERT INTO sales (emp_id) VALUES ($1);", [4])
    end

    if sale[:customer_and_account_no].include?("Motorola")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [1])
    elsif sale[:customer_and_account_no].include?("LG")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [2])
    elsif sale[:customer_and_account_no].include?("HTC")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [3])
    elsif sale[:customer_and_account_no].include?("Nokia")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [4])
    elsif sale[:customer_and_account_no].include?("Samsung")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [5])
    elsif sale[:customer_and_account_no].include?("Apple")
      conn.exec_params("INSERT INTO sales (cust_id) VALUES ($1);", [6])
    end

    if sale[:invoice_frequency].include?("Monthly")
      conn.exec_params("INSERT INTO sales (frequency) VALUES ($1);", [1])
    elsif sale[:invoice_frequency].include?("Quarterly")
      conn.exec_params("INSERT INTO sales (frequency) VALUES ($1);", [2])
    elsif sale[:invoice_frequency].include?("Once")
      conn.exec_params("INSERT INTO sales (frequency) VALUES ($1);", [3])
    end

  end
end
