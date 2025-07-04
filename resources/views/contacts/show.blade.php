@extends('layouts.app')

@section('title', $contact->full_name ?: 'Contact Details')

@section('page-title', $contact->full_name ?: 'Contact Details')

@section('page-actions')
    <div class="btn-group">
        <a href="{{ route('contacts.edit', $contact) }}" class="btn btn-warning">
            <i class="fas fa-edit me-1"></i>
            Edit
        </a>
        <form method="POST" action="{{ route('contacts.destroy', $contact) }}" 
              style="display: inline;" 
              onsubmit="return confirm('Are you sure you want to delete this contact?')">
            @csrf
            @method('DELETE')
            <button type="submit" class="btn btn-danger">
                <i class="fas fa-trash me-1"></i>
                Delete
            </button>
        </form>
        <a href="{{ route('contacts.index') }}" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i>
            Back to Contacts
        </a>
    </div>
@endsection

@section('content')
<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Contact Information</h5>
            </div>
            <div class="card-body">
                <!-- Personal Information -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h6 class="text-muted border-bottom pb-2 mb-3">Personal Information</h6>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">First Name</label>
                        <div class="fw-medium">{{ $contact->first_name ?: '-' }}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Last Name</label>
                        <div class="fw-medium">{{ $contact->last_name ?: '-' }}</div>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h6 class="text-muted border-bottom pb-2 mb-3">Contact Information</h6>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Email</label>
                        <div class="fw-medium">
                            @if($contact->email)
                                <a href="mailto:{{ $contact->email }}" class="text-decoration-none">
                                    {{ $contact->email }}
                                </a>
                            @else
                                -
                            @endif
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Phone</label>
                        <div class="fw-medium">
                            @if($contact->phone)
                                <a href="tel:{{ $contact->phone }}" class="text-decoration-none">
                                    {{ $contact->phone }}
                                </a>
                            @else
                                -
                            @endif
                        </div>
                    </div>
                </div>

                <!-- Address Information -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h6 class="text-muted border-bottom pb-2 mb-3">Address Information</h6>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label text-muted small">Address</label>
                        <div class="fw-medium">{{ $contact->address ?: '-' }}</div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label text-muted small">City</label>
                        <div class="fw-medium">{{ $contact->city ?: '-' }}</div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label text-muted small">State</label>
                        <div class="fw-medium">{{ $contact->state ?: '-' }}</div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label text-muted small">Postal Code</label>
                        <div class="fw-medium">{{ $contact->postal_code ?: '-' }}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Country</label>
                        <div class="fw-medium">{{ $contact->country ?: '-' }}</div>
                    </div>
                </div>

                <!-- Professional Information -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h6 class="text-muted border-bottom pb-2 mb-3">Professional Information</h6>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Company</label>
                        <div class="fw-medium">{{ $contact->company ?: '-' }}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Job Title</label>
                        <div class="fw-medium">{{ $contact->job_title ?: '-' }}</div>
                    </div>
                </div>

                <!-- Notes -->
                @if($contact->notes)
                    <div class="row mb-4">
                        <div class="col-12">
                            <h6 class="text-muted border-bottom pb-2 mb-3">Notes</h6>
                        </div>
                        <div class="col-12">
                            <div class="bg-light p-3 rounded">
                                {!! nl2br(e($contact->notes)) !!}
                            </div>
                        </div>
                    </div>
                @endif

                <!-- Timestamps -->
                <div class="row">
                    <div class="col-12">
                        <h6 class="text-muted border-bottom pb-2 mb-3">System Information</h6>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Created</label>
                        <div class="fw-medium">{{ $contact->created_at->format('M d, Y \a\t g:i A') }}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted small">Last Updated</label>
                        <div class="fw-medium">{{ $contact->updated_at->format('M d, Y \a\t g:i A') }}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <!-- Quick Actions -->
        <div class="card mb-4">
            <div class="card-header">
                <h6 class="card-title mb-0">Quick Actions</h6>
            </div>
            <div class="card-body">
                @if($contact->email)
                    <a href="mailto:{{ $contact->email }}" class="btn btn-outline-primary btn-sm w-100 mb-2">
                        <i class="fas fa-envelope me-2"></i>
                        Send Email
                    </a>
                @endif
                
                @if($contact->phone)
                    <a href="tel:{{ $contact->phone }}" class="btn btn-outline-success btn-sm w-100 mb-2">
                        <i class="fas fa-phone me-2"></i>
                        Call Contact
                    </a>
                @endif

                @if($contact->address || $contact->city || $contact->state || $contact->country)
                    @php
                        $address = implode(', ', array_filter([
                            $contact->address,
                            $contact->city,
                            $contact->state,
                            $contact->postal_code,
                            $contact->country
                        ]));
                    @endphp
                    <a href="https://maps.google.com/maps?q={{ urlencode($address) }}" 
                       target="_blank" class="btn btn-outline-info btn-sm w-100 mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        View on Map
                    </a>
                @endif
            </div>
        </div>

        <!-- Contact Summary -->
        <div class="card">
            <div class="card-header">
                <h6 class="card-title mb-0">Contact Summary</h6>
            </div>
            <div class="card-body">
                <div class="text-center mb-3">
                    <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center" 
                         style="width: 60px; height: 60px; font-size: 24px;">
                        @if($contact->first_name || $contact->last_name)
                            {{ strtoupper(substr($contact->first_name, 0, 1) . substr($contact->last_name, 0, 1)) }}
                        @else
                            <i class="fas fa-user"></i>
                        @endif
                    </div>
                    <h5 class="mt-2 mb-0">{{ $contact->full_name ?: 'No Name' }}</h5>
                    @if($contact->job_title || $contact->company)
                        <small class="text-muted">
                            @if($contact->job_title){{ $contact->job_title }}@endif
                            @if($contact->company && $contact->job_title) at @endif
                            @if($contact->company){{ $contact->company }}@endif
                        </small>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection