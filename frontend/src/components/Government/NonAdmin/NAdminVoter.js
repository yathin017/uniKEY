import React from 'react'
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminVoter() {
  return (
    <div>
      <Link to="/government/admin-voter">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminVoter
    </div>
  )
}
