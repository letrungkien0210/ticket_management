import React from 'react'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
        <h1 className="text-4xl font-bold text-center">
          Ticket Management System
        </h1>
      </div>

      <div className="relative flex place-items-center">
        <div className="text-center">
          <h2 className="mb-3 text-2xl font-semibold">
            Customer Information Management + QR Code Check-in Demo
          </h2>
          <p className="m-0 max-w-[30ch] text-sm opacity-50">
            Welcome to the Ticket Management System. This is a demo application
            for customer information management and QR code check-in functionality.
          </p>
        </div>
      </div>

      <div className="mb-32 grid text-center lg:max-w-5xl lg:w-full lg:mb-0 lg:grid-cols-4 lg:text-left">
        <div className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100">
          <h3 className="mb-3 text-2xl font-semibold">
            Admin Portal
          </h3>
          <p className="m-0 max-w-[30ch] text-sm opacity-50">
            Manage customers, events, and view analytics.
          </p>
        </div>

        <div className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100">
          <h3 className="mb-3 text-2xl font-semibold">
            Customer Portal
          </h3>
          <p className="m-0 max-w-[30ch] text-sm opacity-50">
            Register for events and manage your profile.
          </p>
        </div>

        <div className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100">
          <h3 className="mb-3 text-2xl font-semibold">
            QR Check-in
          </h3>
          <p className="m-0 max-w-[30ch] text-sm opacity-50">
            Quick and easy event check-in using QR codes.
          </p>
        </div>

        <div className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100">
          <h3 className="mb-3 text-2xl font-semibold">
            Analytics
          </h3>
          <p className="m-0 max-w-[30ch] text-sm opacity-50">
            View attendance reports and customer insights.
          </p>
        </div>
      </div>
    </main>
  )
} 