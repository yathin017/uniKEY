import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminPan() {
  return (
    <div>
      <Link to="/government/admin-pan">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminPan
    </div>
  )
}
