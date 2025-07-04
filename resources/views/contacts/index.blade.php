@extends('layouts.app')

@section('title', 'All Contacts')

@section('page-title', 'All Contacts')

@section('page-actions')
    <a href="{{ route('contacts.create') }}" class="btn btn-primary">
        <i class="fas fa-plus me-1"></i>
        Add New Contact
    </a>
@endsection

@section('content')
<div class="row mb-4">
    <div class="col-md-6">
        <form method="GET" action="{{ route('contacts.index') }}" class="d-flex">
            <input type="text" name="search" class="form-control me-2" 
                   placeholder="Search contacts..." value="{{ $search }}">
            <button type="submit" class="btn btn-outline-primary">
                <i class="fas fa-search"></i>
            </button>
            @if($search)
                <a href="{{ route('contacts.index') }}" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-times"></i>
                </a>
            @endif
        </form>
    </div>
    <div class="col-md-6 text-end">
        <span class="text-muted">{{ $contacts->total() }} contact(s) found</span>
    </div>
</div>

@if($contacts->count() > 0)
    <div class="row">
        @foreach($contacts as $contact)
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card contact-card h-100">
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="{{ route('contacts.show', $contact) }}" class="text-decoration-none">
                                {{ $contact->full_name ?: 'No Name' }}
                            </a>
                        </h5>
                        
                        @if($contact->company || $contact->job_title)
                            <p class="text-muted mb-2">
                                @if($contact->job_title){{ $contact->job_title }}@endif
                                @if($contact->company && $contact->job_title) at @endif
                                @if($contact->company){{ $contact->company }}@endif
                            </p>
                        @endif

                        @if($contact->email)
                            <p class="mb-1">
                                <i class="fas fa-envelope text-muted me-2"></i>
                                <a href="mailto:{{ $contact->email }}" class="text-decoration-none">
                                    {{ $contact->email }}
                                </a>
                            </p>
                        @endif

                        @if($contact->phone)
                            <p class="mb-1">
                                <i class="fas fa-phone text-muted me-2"></i>
                                <a href="tel:{{ $contact->phone }}" class="text-decoration-none">
                                    {{ $contact->phone }}
                                </a>
                            </p>
                        @endif

                        @if($contact->city || $contact->state || $contact->country)
                            <p class="mb-1">
                                <i class="fas fa-map-marker-alt text-muted me-2"></i>
                                <small class="text-muted">
                                    @if($contact->city){{ $contact->city }}@endif
                                    @if($contact->state && $contact->city), @endif
                                    @if($contact->state){{ $contact->state }}@endif
                                    @if($contact->country && ($contact->city || $contact->state)), @endif
                                    @if($contact->country){{ $contact->country }}@endif
                                </small>
                            </p>
                        @endif

                        <div class="mt-3">
                            <div class="btn-group" role="group">
                                <a href="{{ route('contacts.show', $contact) }}" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="{{ route('contacts.edit', $contact) }}" 
                                   class="btn btn-sm btn-outline-warning">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form method="POST" action="{{ route('contacts.destroy', $contact) }}" 
                                      style="display: inline;" 
                                      onsubmit="return confirm('Are you sure you want to delete this contact?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    </div>

    <!-- Pagination -->
    <div class="d-flex justify-content-center">
        {{ $contacts->appends(['search' => $search])->links() }}
    </div>
@else
    <div class="text-center py-5">
        <i class="fas fa-users fa-3x text-muted mb-3"></i>
        <h4 class="text-muted">No contacts found</h4>
        @if($search)
            <p class="text-muted">No contacts match your search criteria.</p>
            <a href="{{ route('contacts.index') }}" class="btn btn-outline-primary">
                <i class="fas fa-list me-2"></i>
                View All Contacts
            </a>
        @else
            <p class="text-muted">Start by adding your first contact.</p>
            <a href="{{ route('contacts.create') }}" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>
                Add Your First Contact
            </a>
        @endif
    </div>
@endif
@endsection