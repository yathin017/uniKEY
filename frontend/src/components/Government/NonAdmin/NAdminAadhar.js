import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminAadhar() {
  return (
    <div>
      <Link to="/government/admin-aadhar">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminAadhar
      </div>
  )
}

