// MongoDB initialization script
// This script will be executed when MongoDB container starts for the first time

print('Starting MongoDB initialization...');

// Switch to the application database
db = db.getSiblingDB('ticket_management');

// Create collections with validation schemas
print('Creating collections...');

// Admins collection
db.createCollection('admins', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['username', 'password_hash', 'role'],
      properties: {
        username: { bsonType: 'string', description: 'Username is required and must be a string' },
        password_hash: { bsonType: 'string', description: 'Password hash is required and must be a string' },
        full_name: { bsonType: 'string', description: 'Full name must be a string' },
        email: { bsonType: 'string', description: 'Email must be a string' },
        role: { bsonType: 'string', enum: ['admin', 'super_admin'], description: 'Role must be admin or super_admin' },
        created_at: { bsonType: 'date', description: 'Created at must be a date' },
        updated_at: { bsonType: 'date', description: 'Updated at must be a date' }
      }
    }
  }
});

// Customers collection
db.createCollection('customers', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['email', 'password_hash', 'full_name'],
      properties: {
        email: { bsonType: 'string', description: 'Email is required and must be a string' },
        password_hash: { bsonType: 'string', description: 'Password hash is required and must be a string' },
        full_name: { bsonType: 'string', description: 'Full name is required and must be a string' },
        phone_number: { bsonType: 'string', description: 'Phone number must be a string' },
        created_at: { bsonType: 'date', description: 'Created at must be a date' },
        updated_at: { bsonType: 'date', description: 'Updated at must be a date' }
      }
    }
  }
});

// Events collection
db.createCollection('events', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['event_name', 'event_date', 'ticket_limit'],
      properties: {
        event_name: { bsonType: 'string', description: 'Event name is required and must be a string' },
        event_date: { bsonType: 'date', description: 'Event date is required and must be a date' },
        description: { bsonType: 'string', description: 'Description must be a string' },
        ticket_limit: { bsonType: 'int', minimum: 1, description: 'Ticket limit is required and must be a positive integer' },
        images: { bsonType: 'array', items: { bsonType: 'string' }, description: 'Images must be an array of strings' },
        created_at: { bsonType: 'date', description: 'Created at must be a date' },
        updated_at: { bsonType: 'date', description: 'Updated at must be a date' }
      }
    }
  }
});

// Tickets collection
db.createCollection('tickets', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['customer_id', 'event_id', 'qr_code_data', 'payment_status', 'check_in_status'],
      properties: {
        customer_id: { bsonType: 'objectId', description: 'Customer ID is required and must be an ObjectId' },
        event_id: { bsonType: 'objectId', description: 'Event ID is required and must be an ObjectId' },
        qr_code_data: { bsonType: 'string', description: 'QR code data is required and must be a string' },
        payment_status: { bsonType: 'string', enum: ['pending', 'completed', 'failed'], description: 'Payment status must be pending, completed, or failed' },
        check_in_status: { bsonType: 'string', enum: ['not_checked_in', 'checked_in'], description: 'Check-in status must be not_checked_in or checked_in' },
        checked_in_at: { bsonType: 'date', description: 'Checked in at must be a date' },
        checked_in_by: { bsonType: 'objectId', description: 'Checked in by must be an ObjectId' },
        created_at: { bsonType: 'date', description: 'Created at must be a date' },
        updated_at: { bsonType: 'date', description: 'Updated at must be a date' }
      }
    }
  }
});

print('Collections created successfully.');

// Create indexes for better performance
print('Creating indexes...');

// Admins indexes
db.admins.createIndex({ 'username': 1 }, { unique: true });
db.admins.createIndex({ 'email': 1 }, { unique: true, sparse: true });

// Customers indexes
db.customers.createIndex({ 'email': 1 }, { unique: true });
db.customers.createIndex({ 'full_name': 'text' });

// Events indexes
db.events.createIndex({ 'event_name': 'text', 'description': 'text' });
db.events.createIndex({ 'event_date': 1 });

// Tickets indexes
db.tickets.createIndex({ 'customer_id': 1 });
db.tickets.createIndex({ 'event_id': 1 });
db.tickets.createIndex({ 'qr_code_data': 1 }, { unique: true });
db.tickets.createIndex({ 'check_in_status': 1 });
db.tickets.createIndex({ 'customer_id': 1, 'event_id': 1 }, { unique: true });

print('Indexes created successfully.');

// Insert sample admin user (password: admin123)
print('Creating default admin user...');

db.admins.insertOne({
  username: 'admin',
  password_hash: '$2a$10$CwTycUXWue0Thq9StjUM0uJ8Z2LKYjDQX1Xb6LsL4Q8Q5X6Z7FG.O', // admin123
  full_name: 'System Administrator',
  email: 'admin@ticketmanagement.com',
  role: 'super_admin',
  created_at: new Date(),
  updated_at: new Date()
});

print('Default admin user created.');
print('Username: admin');
print('Password: admin123');

print('MongoDB initialization completed successfully!'); 