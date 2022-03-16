import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminHealthcare() {
  return (
    <div>
      <Link to="/admin-healthcare">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminHealthcare
    </div>
  )
}
