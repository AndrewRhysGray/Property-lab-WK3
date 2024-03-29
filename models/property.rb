require('pg')

class Property

attr_reader :id
attr_accessor :address, :value, :number_of_bedrooms, :year_built

  def initialize ( details )
    @id = details['id'].to_i() if details['id']
    @address = details['address']
    @value = details['value']
    @number_of_bedrooms = details['number_of_bedrooms']
    @year_built = details['year_built']
  end

  def save()
    db = PG.connect({ dbname: 'property_lab', host: 'localhost' })
    sql =
      "INSERT INTO track_properties (
        address,
        value,
        number_of_bedrooms,
        year_built
      ) VALUES ($1, $2, $3, $4) RETURNING id;"
    values = [@address, @value, @number_of_bedrooms, @year_built]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]['id'].to_i()
    db.close()
  end

  def update()
    db = PG.connect({ dbname: 'property_lab', host: 'localhost' })
    sql =
    "UPDATE track_properties SET (
      address,
      value,
      number_of_bedrooms,
      year_built
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5;"
    values = [@address, @value, @number_of_bedrooms, @year_built, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def delete()
    db = PG.connect({ dbname: 'property_lab', host: 'localhost' })
    sql =
    "DELETE FROM track_properties WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close()
  end

end
